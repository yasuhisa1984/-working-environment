return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("chatgpt").setup({
			api_key_cmd = "echo $OPENAI_API_KEY",
		})
	end,
}
