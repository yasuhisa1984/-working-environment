if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")
local lspconfig = require("lspconfig")
lspconfig.intelephense.setup({})

require("config.unmap_lsp_k")

require("oil").setup()
