-- git のブランチ名を「git を起動せずに」取る。
--
-- なぜ .git/HEAD を直接読むのか:
--   harpoon の settings.key はリスト操作のたびに呼ばれる。
--   Mac mini M4 / Neovim 0.12 / この設定を読み込んだ状態での実測 (各100回):
--     vim.fn.system("git rev-parse --abbrev-ref HEAD")  70.694 ms
--     vim.system({"git","rev-parse",...}):wait()         9.965 ms
--     .git/HEAD を読むだけ                               0.010 ms
--   古い API はエディタ本体を複製してから起動するので、プラグインが多いほど高くつく。
local M = {}

local head_path_cache = {} -- cwd -> HEAD のパス。ここは滅多に変わらないのでキャッシュ

local function resolve_head_path(cwd)
  local cached = head_path_cache[cwd]
  if cached ~= nil then
    return cached
  end

  local found = vim.fs.find(".git", { upward = true, path = cwd })[1]
  if not found then
    head_path_cache[cwd] = false
    return false
  end

  local gitdir = found
  local stat = vim.uv.fs_stat(found)
  if stat and stat.type == "file" then
    -- worktree / submodule では .git が「gitdir: <path>」のテキストファイルになる
    local fh = io.open(found, "r")
    local line = fh and fh:read("l")
    if fh then
      fh:close()
    end
    gitdir = line and line:match("^gitdir:%s*(.+)$")
    if not gitdir then
      head_path_cache[cwd] = false
      return false
    end
  end

  head_path_cache[cwd] = gitdir .. "/HEAD"
  return head_path_cache[cwd]
end

--- 現在のブランチ名。git 管理下でなければ nil
function M.branch(cwd)
  local head = resolve_head_path(cwd or vim.uv.cwd())
  if not head then
    return nil
  end
  local fh = io.open(head, "r")
  if not fh then
    return nil
  end
  local line = fh:read("l")
  fh:close()
  if not line then
    return nil
  end
  -- 通常は "ref: refs/heads/<branch>"、detached HEAD なら生の SHA
  return line:match("^ref: refs/heads/(.+)$") or ("detached-" .. line:sub(1, 7))
end

--- harpoon の settings.key 用。git 配下なら "<cwd>#<branch>"、外なら "<cwd>"
function M.key(cwd)
  cwd = cwd or vim.uv.cwd()
  local branch = M.branch(cwd)
  return branch and (cwd .. "#" .. branch) or cwd
end

--- .git の場所を探し直す (worktree を作った直後など)
function M.forget()
  head_path_cache = {}
end

return M
