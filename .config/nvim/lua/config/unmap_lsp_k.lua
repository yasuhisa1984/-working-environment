-- ~/.config/nvim/lua/config/unmap_lsp_k.lua
-- K は 10k 移動に使うため、LSP/LazyVim/noice 等が設定するバッファローカル K を上書きする
local aug = vim.api.nvim_create_augroup("my_lsp_keyfix", {})

local function override_K(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	pcall(vim.keymap.del, "n", "K", { buffer = buf })
	vim.keymap.set("n", "K", "10k", { buffer = buf, noremap = true, silent = true, desc = "Move 10 lines up" })
	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { buffer = buf, desc = "LSP Hover" })
end

-- LspAttach のたびに複数回遅延して上書き（他プラグインのタイミングに勝つ）
vim.api.nvim_create_autocmd("LspAttach", {
	group = aug,
	callback = function(ev)
		for _, ms in ipairs({ 0, 50, 200, 500 }) do
			vim.defer_fn(function()
				override_K(ev.buf)
			end, ms)
		end
	end,
})
