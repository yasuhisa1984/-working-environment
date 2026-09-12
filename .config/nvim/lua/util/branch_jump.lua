-- <leader>gb : Telescope でブランチを選び、移動して「そのブランチの作業位置」まで復元する。
--
-- 設計方針: **自動 stash はしない**。
--   git は、作業が消えるような checkout は自分で断る (実測で確認済み):
--     - 別ファイルの編集中        → そのまま持って移動できる (stash 不要)
--     - 同じファイルの編集中      → "local changes would be overwritten" で中止
--     - 未追跡ファイルが衝突      → "untracked working tree files" で中止
--   つまり黙って消えることはない。勝手に stash すると「隠したこと」を人間が覚えておく必要が
--   出てきて、そっちの方が事故る。断られたら、何が起きたかを見せて人間に決めてもらう。
--
--   worktree は選択肢に入れない: Mutagen で開発サーバーと同期しているため、
--   別フォルダを作っても同期セッションの外になる。作業ディレクトリは常に1つ。
local M = {}

local branchkey = require("util.branchkey")

local function open_harpoon_first()
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    return
  end
  local list = harpoon:list()
  if #list.items > 0 then
    list:select(1)
  end
end

--- checkout が断られたときに、選べる道を出す (勝手にやらない)
local function explain_refusal(branch, stderr)
  vim.notify(stderr, vim.log.levels.WARN, { title = "checkout できなかった" })
  vim.ui.select({
    "WIPコミットして移動 (おすすめ。ブランチに残るので忘れない)",
    "stash して移動 (-u つき。新規ファイルも一緒にしまう)",
    "何が引っかかっているか見る",
  }, { prompt = branch .. " に移動できない。どうする?" }, function(choice)
    if not choice then
      return
    end
    if choice:match("^WIP") then
      -- stash より WIP コミットを推す理由:
      --   git log に残るので「しまったこと」を忘れない。戻したいときは
      --   git reset HEAD^ で、コミット前の状態にそのまま戻る。
      vim.system({ "git", "add", "-A" }, { text = true }):wait()
      local r = vim.system({ "git", "commit", "-m", "WIP (branch_jump)" }, { text = true }):wait()
      if r.code ~= 0 then
        return vim.notify(r.stderr, vim.log.levels.ERROR)
      end
      local from = branchkey.branch()
      M.jump(branch)
      vim.notify(
        ("%s に WIP コミットを置いた。\n戻ったら  git reset HEAD^  で元の状態に戻せる"):format(from),
        vim.log.levels.INFO
      )
    elseif choice:match("^stash") then
      local r = vim.system({ "git", "stash", "push", "-u", "-m", "branch_jump" }, { text = true }):wait()
      if r.code ~= 0 then
        return vim.notify(r.stderr, vim.log.levels.ERROR)
      end
      M.jump(branch)
      vim.notify("stash した。戻すときは  git stash pop", vim.log.levels.WARN)
    else
      vim.cmd("botright split | terminal git status --short && git diff --stat")
    end
  end)
end

--- 指定ブランチへ移動して、作業位置を復元する
function M.jump(branch)
  local res = vim.system({ "git", "checkout", branch }, { text = true }):wait()
  if res.code ~= 0 then
    return explain_refusal(branch, res.stderr)
  end
  branchkey.forget()
  vim.cmd("checktime") -- 開いているバッファを新しい内容に追従させる
  vim.notify("→ " .. branch, vim.log.levels.INFO, { title = "branch jump" })
  open_harpoon_first()
end

--- Telescope のブランチ一覧を出す
function M.pick()
  local ok = pcall(require, "telescope")
  if not ok then
    return vim.notify("telescope が無い", vim.log.levels.ERROR)
  end
  require("telescope.builtin").git_branches({
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry then
          M.jump(entry.value)
        end
      end)
      return true
    end,
  })
end

return M
