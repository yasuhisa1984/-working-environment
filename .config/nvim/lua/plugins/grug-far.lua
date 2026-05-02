return {
	"MagicDuck/grug-far.nvim",
	keys = {
		{
			"<leader>sw",
			function()
				require("grug-far").open({
					prefills = { search = vim.fn.expand("<cword>") },
				})
			end,
			desc = "grug-far: word under cursor",
		},
	},
}
