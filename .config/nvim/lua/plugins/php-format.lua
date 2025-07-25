-- lua/plugins/php-format.lua
-- コメントは日本語で記載しています（省略なし）

return {
	"stevearc/conform.nvim",
	ft = "php",
	opts = function(_, opts)
		opts.formatters_by_ft = opts.formatters_by_ft or {}
		opts.formatters = opts.formatters or {}

		-- PHP では php_cs_fixer だけを使う
		opts.formatters_by_ft.php = { "php_cs_fixer" }

		-- stdin=false にして、ファイルパスを渡す
		opts.formatters.php_cs_fixer = {
			command = "/Users/yasuhisa/.composer/vendor/bin/php-cs-fixer", -- フルパスでOK
			args = { "fix", "--quiet", "--using-cache=no", "$FILENAME" }, -- stdinは使わない
			stdin = false,
			-- なくても動くが安全策としてtmpファイル方式も可
			-- tmpfile_format = ".conform_%s",
		}
	end,
}
