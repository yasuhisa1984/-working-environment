-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		vim.opt_local.tabstop = 4 -- 表示上の幅
		vim.opt_local.shiftwidth = 4 -- >> / << で動く幅
		vim.opt_local.expandtab = true -- Tab → スペース変換
	end,
})
