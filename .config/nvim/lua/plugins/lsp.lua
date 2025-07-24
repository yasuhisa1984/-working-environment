return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
			})
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		-- `opts`を関数として定義し、デフォルトのoptsテーブルを引数として受け取る
		opts = function(_, opts)
			-- 1. サーバー設定をデフォルトのopts.serversにマージする
			--    vim.tbl_deep_extendを使うことで、既存の設定を上書きせずに追記できる
			opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
				cssls = {},
				tailwindcss = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
				},
				intelephense = {
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("composer.json", ".git")(fname) or vim.fn.getcwd()
					end,
					settings = {
						intelephense = {
							format = { enable = false },
							environment = { includePaths = { "vendor" } },
							stubs = {
								"apache",
								"bcmath",
								"bz2",
								"calendar",
								"com_dotnet",
								"Core",
								"ctype",
								"curl",
								"date",
								"dom",
								"exif",
								"fileinfo",
								"filter",
								"ftp",
								"gd",
								"gettext",
								"gmp",
								"hash",
								"iconv",
								"imap",
								"intl",
								"json",
								"ldap",
								"libxml",
								"mbstring",
								"mcrypt",
								"mysql",
								"mysqli",
								"openssl",
								"pcntl",
								"pcre",
								"PDO",
								"pdo_mysql",
								"pdo_sqlite",
								"Phar",
								"posix",
								"readline",
								"Reflection",
								"session",
								"SimpleXML",
								"soap",
								"sockets",
								"sodium",
								"SPL",
								"standard",
								"superglobals",
								"tokenizer",
								"xml",
								"xmlreader",
								"xmlrpc",
								"xmlwriter",
								"Zend OPcache",
								"zip",
								"zlib",
							},
							files = { maxSize = 5000000 },
						},
					},
				},
				tsserver = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				html = {},
				yamlls = {
					settings = { yaml = { keyOrdering = false } },
				},
				lua_ls = {
					single_file_support = true,
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							completion = { workspaceWord = true, callSnippet = "Both" },
							misc = { parameters = {} },
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = { privateName = { "^_" } },
							type = { castNumberToInteger = true },
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								groupSeverity = { strong = "Warning", strict = "Warning" },
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
			})

			-- 2. 他のトップレベル設定をマージする
			opts.inlay_hints = { enabled = false }

			opts.keys = opts.keys or {}
			-- 3. キーマップをデフォルトのopts.keysに追加する
			vim.list_extend(opts.keys, {
				{ "n", "K", false }, -- ① 既定の K を無効化
				{ "n", "<leader>h", vim.lsp.buf.hover, desc = "LSP Hover" },
				{
					"n",
					"gd",
					function()
						-- Telescope を使わず自前で定義へジャンプ
						vim.lsp.buf.definition()
					end,
					desc = "Goto Definition",
					has = "definition",
				},
			})

			-- 4. 最後に、完成したoptsテーブルを必ずreturnする
			return opts
		end,
	},
}
