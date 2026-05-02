return {
	-- 既存: solarized-osaka は引き続き使えるよう lazy 状態で保持
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},

	-- midnight 系（TokyoNight night スタイル）
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},

	-- LazyVim にデフォルト colorscheme を tokyonight-night として指定
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight-night",
		},
	},

	-- 使用しないカラースキームは無効化
	{ "catppuccin/nvim", enabled = false },
}
