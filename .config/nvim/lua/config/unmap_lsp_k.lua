-- ~/.config/nvim/lua/config/unmap_lsp_k.lua
local aug = vim.api.nvim_create_augroup("my_lsp_keyfix", {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = aug,
	callback = function(ev)
		-- LSP が設定する K(Hover) を削除
		pcall(vim.keymap.del, "n", "K", { buffer = ev.buf })
		-- ついでに Hover を <leader>h にバッファローカルで貼り直す
		vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP Hover" })
	end,
})
