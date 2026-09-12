-- staff.nvim : Neovim を「AI社員を管理する開発コックピット」にする自作プラグイン。
-- 開発中はローカルディレクトリを直接読む。
return {
	dir = vim.fn.expand("~/workspace/staff.nvim"),
	name = "staff.nvim",
	lazy = false,
	opts = {
		privacy = { mode = "local_only" },
		providers = {
			local_llm = { type = "ollama", model = "qwen3.5:4b", tier = "local" },
			-- cheap / smart は、会社で使う provider が決まってからここへ足す
		},
		cost = { daily_budget_usd = 1.00, auto_escalate = false },
	},
	config = function(_, opts)
		require("staff").setup(opts)
	end,
}
