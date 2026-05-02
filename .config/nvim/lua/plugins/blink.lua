-- ~/.config/nvim/lua/plugins/blink.lua
return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		opts = {
			-- ① デフォルトの並び順
			sources = {
				default = { "lsp", "copilot", "path", "snippets", "buffer" },

				-- ② 追加 provider 一覧
				providers = {
					copilot = {
						name = "Copilot", -- ラベル
						module = "blink-cmp-copilot", -- プラグイン名
						async = true, -- 非同期で取得
						score_offset = 80, -- LSP より少し下げる
					},
				},
			},
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "saghen/blink.compat", optional = true },
		},
	},
}
