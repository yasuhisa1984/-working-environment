-- avante.nvim : Neovim を Cursor のように使う AI アシスタント。
-- ここではクラウドではなく、手元の ollama (ローカルLLM) を使う設定にしている。
-- 理由: コードを外に出さずに済む / 無料 / 回数制限がない。
return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	-- ★ build = "make" は Rust(cargo) が必須。入っていないと
	--   "make: cargo: No such file or directory" で失敗する。
	--   build.sh ならプリビルドの .so を落としてくるので cargo 不要。
	build = "sh build.sh",
	opts = {
		provider = "ollama",
		providers = {
			ollama = {
				endpoint = "http://127.0.0.1:11434",
				model = "qwen3.5:4b",
				-- ★ ツールを使わせない。avante は既定でエージェントとして動き、
				--   ファイル読み書きや診断取得のツールをモデルに使わせる。
				--   小さいローカルモデルはこれについていけず、存在しないファイルを
				--   読もうとしたり、質問と無関係な思考を始めて止まらなくなる (実測)。
				--   切ると、ただのチャットとして素直に答えるようになる。
				disable_tools = true,
				-- temperature / num_ctx などは extra_request_body の下へ (新しい書き方)
				extra_request_body = {
					-- ★ これが最重要。qwen3 系は「考えてから答える」モデルで、
					--   既定のままだと回答前に数千トークン考え込む。実測 (Mac mini M4):
					--     思考オン : 229.1 秒 (思考 5118 トークン)
					--     思考オフ :   1.8 秒
					--   127 倍違う。しかも回答の質は落ちなかった。
					think = false,
					options = {
						num_ctx = 8192,
						temperature = 0.2,
					},
				},
			},
		},
		behaviour = {
			auto_suggestions = false, -- 補完の自動提案はローカルだと重いので切る
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
		"MeanderingProgrammer/render-markdown.nvim",
	},
}
