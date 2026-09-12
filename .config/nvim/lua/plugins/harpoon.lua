return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>ha",
			function()
				require("harpoon"):list():add()
			end,
			desc = "Harpoon add",
		},
		{
			"<leader>hh",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Harpoon menu",
		},
		{
			"<leader>1",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Harpoon 1",
		},
		{
			"<leader>2",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Harpoon 2",
		},
		{
			"<leader>3",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Harpoon 3",
		},
		{
			"<leader>4",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "Harpoon 4",
		},
	},
	config = function()
		local branchkey = require("util.branchkey")
		require("harpoon"):setup({
			settings = {
				-- ★ブランチごとに別のリストにする。
				-- 既定は cwd だけなので、ブランチを切り替えても同じ4本が出てくる。
				-- cwd + ブランチ名にすると <leader>1..4 がブランチ単位で切り替わる。
				key = function()
					return branchkey.key()
				end,
			},
		})

		-- <leader>gb : Telescope でブランチを選び、移動して作業位置まで復元する
		vim.keymap.set("n", "<leader>gb", function()
			require("util.branch_jump").pick()
		end, { desc = "Branch: 選んで移動 + 作業位置を復元" })

		-- 今どのブランチのリストを見ているかを出す (自慢用)
		vim.keymap.set("n", "<leader>hb", function()
			local b = branchkey.branch()
			vim.notify(b and ("harpoon: " .. b) or "harpoon: git 管理外 (cwd 単位)")
		end, { desc = "Harpoon: 今のリストのブランチ" })
	end,
}
