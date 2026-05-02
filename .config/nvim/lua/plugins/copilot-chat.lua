return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
		},
		build = "make tiktoken",
		cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatReset", "CopilotChatClose", "CopilotChatModels" },
		opts = {
			model = "gpt-4.1",
			window = {
				layout = "vertical",
				width = 0.4,
			},
		},
		keys = {
			{ "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
			{ "<leader>ax", "<cmd>CopilotChatReset<cr>", desc = "Copilot Chat Reset" },
			{ "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "Copilot Chat Close" },
			{
				"<leader>ae",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "Quick Chat (Buffer)",
			},
			{
				"<leader>ae",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
					end
				end,
				mode = "v",
				desc = "Quick Chat (Selection)",
			},
		},
	},
}
