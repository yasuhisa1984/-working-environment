# Neovim (LazyVim) 操作ガイド

LazyVim ベースに Code Craft カスタマイズを加えた個人 Neovim 環境。
Leader キーは `<Space>`。

---

## 目次

1. [基本移動・編集](#基本移動編集)
2. [高速移動・ジャンプ (flash.nvim)](#高速移動ジャンプ-flashnvim)
3. [ファイル切替 (harpoon)](#ファイル切替-harpoon)
4. [ウィンドウ・タブ操作](#ウィンドウタブ操作)
5. [ファイル検索・ナビゲーション (Telescope)](#ファイル検索ナビゲーション-telescope)
6. [ファイルエクスプローラー (Oil.nvim)](#ファイルエクスプローラー-oilnvim)
7. [折りたたみ (nvim-ufo)](#折りたたみ-nvim-ufo)
8. [LSP (コード補完・定義ジャンプ)](#lsp-コード補完定義ジャンプ)
9. [補完 (blink.cmp)](#補完-blinkcmp)
10. [AI アシスタント (Copilot)](#ai-アシスタント-copilot)
11. [Git 操作](#git-操作)
12. [UI プラグイン](#ui-プラグイン)
13. [編集支援プラグイン](#編集支援プラグイン)
14. [Vim 矯正ギプス (hardtime / precognition)](#vim-矯正ギプス-hardtime--precognition)
15. [便利機能](#便利機能)
16. [対応言語](#対応言語)
17. [エラー・ログ調査ツール](#エラーログ調査ツール)
18. [カスタマイズの仕組み](#カスタマイズの仕組み)

---

## 基本移動・編集

### 高速移動

| キー | 動作 |
|------|------|
| `H` | 左に10文字移動 |
| `J` | 下に10行移動 |
| `K` | 上に10行移動 |
| `L` | 右に10文字移動 |
| `vv` | 矩形選択 (Visual Block) |
| `<C-a>` | 全選択 |

> **注意**: `K` は通常 LSP Hover だが、この設定では `10k`（10行上移動）に変更済み。
> LSP Hover は `<Space>h` で使える。
> この上書きは `lua/config/unmap_lsp_k.lua` で行っており、LazyVim や noice.nvim が
> 後から `K` を再設定するのを防ぐため `vim.defer_fn` で複数回上書きしている。

### レジスタを汚さない操作

通常の `d` や `c` はヤンクレジスタを上書きするが、以下はレジスタを汚さない：

| キー | 動作 |
|------|------|
| `x` | 1文字削除（レジスタに入れない） |
| `<Space>d` / `<Space>D` | 削除（レジスタに入れない） |
| `<Space>c` / `<Space>C` | 変更（レジスタに入れない） |
| `<Space>p` / `<Space>P` | レジスタ0からペースト（直前のヤンク） |
| `dw` | 単語を後方削除 |

### 検索・置換テクニック

場面によって最適な方法が異なる。

| やりたいこと | 最適な方法 |
|---|---|
| 変数・関数名の変更 | `<Space>cr`（LSP リネーム） |
| ファイル内の文字列置換 | `:%s/old/new/gc` |
| プロジェクト全体の置換 | `<Space>sr`（grug-far） |
| カーソル下の単語をプロジェクト全体置換 | `<Space>sw`（grug-far + プリフィル） |
| 数箇所だけ手動で置換 | `*` → `cgn` → Esc → `.` で繰り返し |

#### cgn パターン（おすすめ）

`*` + `n` + `.` よりも効率的。`.` だけで「次のマッチに移動して置換」が一発でできる。

```
1. 置換したい単語にカーソルを置く
2. * で検索（単語がハイライトされる）
3. cgn と入力（次のマッチが選択され、入力モードに入る）
4. 新しい文字列を入力して Esc
5. . を押すと次のマッチも同じ置換が実行される
6. スキップしたい場合は n で飛ばして . で次を置換
```

> `cgn` = "change (the) g(lobal) n(ext match)" の意。Vim 組み込み機能なのでプラグイン不要。

#### :%s コマンド

```vim
:%s/old/new/gc    " 全行・確認付き（y/n で1つずつ選べる）
:%s/old/new/g     " 全行・一括置換（確認なし）
:10,50s/old/new/g " 10〜50行目だけ置換
```

#### grug-far.nvim（プロジェクト全体の置換）

| キー | 動作 |
|---|---|
| `<Space>sr` | grug-far 起動（カレントバッファの拡張子で `*.ext` を自動プリフィル） |
| `<Space>sw` | カーソル下の単語をプリフィルして起動（一括リネーム用） |
| `:GrugFar` | コマンドで起動 |
| `:GrugFarWithin` | 選択範囲のみ対象に起動 |

#### grug-far バッファ内の操作

```
1. 専用バッファに「Search / Replace / Files Filter / Files include」セクションが並ぶ
2. それぞれの行を普通のバッファ編集として書き換え
3. 結果プレビューがリアルタイム更新される
4. <localleader>r （= \r）で一括置換実行
5. q で閉じる
```

LSP が効かない文字列（クラス名、設定値、コメントなど）の一括置換に最適。

### 数値操作

| キー | 動作 |
|------|------|
| `+` / `<C-a>` | 数値をインクリメント |
| `-` / `<C-x>` | 数値をデクリメント |

dial.nvim による拡張：日付 (`YYYY/MM/DD`)、`true`/`false`、セマンティックバージョン、`let`/`const` の切り替えにも対応。

### 空行の挿入

| キー | 動作 |
|------|------|
| `<Space>o` | 下に空行（インデントなし） |
| `<Space>O` | 上に空行（インデントなし） |

---

## 高速移動・ジャンプ (flash.nvim)

`/` 検索や `f`/`t` モーションを大幅に置き換える、画面内 2 文字ジャンプ。

| キー | モード | 動作 |
|------|------|------|
| `s` | n / x / o | 2 文字（or 任意キー）で画面内の任意位置にジャンプ |
| `S` | n / x / o | **Treesitter モード**：関数・if 文・式単位で選択ジャンプ |
| `r` | o | Remote Flash（オペレータ + 別の場所のテキスト操作） |

### 使いどころ

- `s` + 移動先の最初の 2 文字 → 表示されるラベルを押すと一瞬でジャンプ。`hjkl` 連打や `/word` の 8 割を置き換える。
- `vS` で「画面内の関数を 1 つ選択」が可能（Treesitter ノード単位）。
- `dap` の代わりに `dS` で「ある関数まるごと削除」など、操作と組み合わせやすい。

---

## ファイル切替 (harpoon)

「いま触っているファイル 4〜5 個を**固定して秒で切替**」専用プラグイン（ThePrimeagen 製・harpoon2）。
**Telescope** はプロジェクト全体探索、**harpoon** は固定の主役ファイル切替、と使い分ける。

| キー | 動作 |
|------|------|
| `<Space>ha` | 現在ファイルを harpoon リストに追加 |
| `<Space>hh` | クイックメニュー（リスト一覧と並べ替え） |
| `<Space>1` | 1 番目のファイルへ |
| `<Space>2` | 2 番目のファイルへ |
| `<Space>3` | 3 番目のファイルへ |
| `<Space>4` | 4 番目のファイルへ |

### 典型的なワークフロー

```
1. controller / service / model / test を順に開く
2. それぞれで <Space>ha でマーク
3. 以降は <Space>1〜4 でノールック切替
```

`<Space>hh` のメニュー上で行を削除・並び替えするとリストが更新される（バッファ編集で OK）。

---

## ウィンドウ・タブ操作

### ウィンドウ分割

| キー | 動作 |
|------|------|
| `ss` | 水平分割 |
| `sv` | 垂直分割 |
| `sh` / `sj` / `sk` / `sl` | フォーカス移動（左/下/上/右） |
| `<C-w>←↑↓→` | ウィンドウリサイズ |

### タブ

| キー | 動作 |
|------|------|
| `te` | 新しいタブを開く |
| `<Tab>` | 次のタブ |
| `<S-Tab>` | 前のタブ |

### バッファ管理 (close-buffers.nvim)

| キー | 動作 |
|------|------|
| `<Space>th` | 非表示バッファを閉じる |
| `<Space>tu` | 名前なしバッファを閉じる |

---

## ファイル検索・ナビゲーション (Telescope)

最も使う機能。ファジーファインダーで何でも素早く見つけられる。

### 基本操作

| キー | 動作 | 使いどころ |
|------|------|-----------|
| `;f` | ファイル検索 | プロジェクト内のファイルを名前で探す |
| `;r` | grep検索 | コード内の文字列を検索 |
| `\\` | バッファ一覧 | 開いているファイルを切り替え |
| `;t` | ヘルプタグ | Neovimのヘルプを検索 |
| `;;` | 前のピッカーを再開 | 直前の検索を続ける |
| `;e` | 診断情報 | エラー・警告の一覧 |
| `;s` | Treesitterシンボル | 関数・変数などの構造を検索 |
| `;c` | LSP呼び出し元 | 関数がどこから呼ばれているか |
| `sf` | ファイルブラウザ | ディレクトリツリーを操作 |
| `<Space>fP` | プラグインファイル | LazyVim プラグインのソースを探索 |

### ファイルブラウザ内の操作

| キー | 動作 |
|------|------|
| `N` | 新規ファイル作成 |
| `h` | 親ディレクトリへ |
| `/` | 検索モード |
| `<C-u>` / `<C-d>` | 10行スクロール |

### 検索のコツ

```
;f → "comp" と入力 → components/ 以下のファイルが候補に
;r → "useState" と入力 → プロジェクト全体から useState を使っている箇所を表示
;s → 現在のファイルの関数一覧をざっと確認してジャンプ
;; → さっきの検索をもう一度（別のを選ぶ）
```

### カスタマイズポイント

- テーマ: horizontal レイアウト、プロンプト上部
- `fzf-native` で高速フィルタリング（C でコンパイル済み）
- `.gitignore` に従ったファイル検索

---

## ファイルエクスプローラー (Oil.nvim)

バッファのようにディレクトリを編集できるファイルマネージャー。

```
:Oil          → カレントディレクトリを開く
```

ファイル名の編集・削除・移動がバッファ操作と同じ感覚でできる。
アイコン表示には mini.icons を使用。

---

## 折りたたみ (nvim-ufo)

Treesitter / LSP / インデント由来の正確な折りたたみ。標準 fold より圧倒的に使える。

| キー | 動作 |
|------|------|
| `zR` | すべての折りたたみを開く |
| `zM` | すべての折りたたみを閉じる |
| `za` | カーソル下の fold をトグル（Vim 標準） |
| `zo` / `zc` | 開く / 閉じる（Vim 標準） |

### 設定

- `foldcolumn = 1`：左端に fold マーカー列を表示
- `foldlevel / foldlevelstart = 99`：起動時はデフォルトで全展開
- provider は **treesitter → indent** の順で fallback

1000 行を超えるファイルで関数単位に畳むと体感生産性が大きく変わる。

---

## LSP (コード補完・定義ジャンプ)

### コードナビゲーション

| キー | 動作 |
|------|------|
| `gd` | 定義にジャンプ |
| `gr` | 参照一覧 |
| `gI` | 実装にジャンプ |
| `gy` | 型定義にジャンプ |
| `gD` | 宣言にジャンプ |
| `gK` | シグネチャヘルプ |
| `<Space>h` | ホバー情報（型・ドキュメント）**※ K ではない** |
| `<Space>ca` | コードアクション |
| `<Space>cr` | リネーム (inc-rename で即時プレビュー) |
| `<Space>co` | import の整理 |
| `<Space>cl` | LSP サーバー情報 |
| `<C-j>` | 次の診断（エラー・警告）へジャンプ |
| `]]` / `[[` | 次/前のリファレンスへ |

### インレイヒント

TypeScript や Lua で型情報をインラインで表示：

```
<Space>i → インレイヒントのトグル
```

デフォルトでは無効。有効にすると関数の引数型・戻り値型が薄く表示される。

### 自動フォーマット (conform.nvim)

```
<Space>tf → バッファごとの自動フォーマットをトグル
```

保存時に自動フォーマットされる。フォーマッターは言語ごとに設定：

| 言語 | フォーマッター |
|------|------------|
| JS/TS/HTML/CSS/JSON | Prettier（プロジェクトに設定ファイルがある場合のみ） |
| PHP | php-cs-fixer（`~/.composer/vendor/bin/php-cs-fixer`） |
| Lua | stylua |
| Rust | rustfmt |

### lsp_signature.nvim（関数引数のヒント）

挿入モードで関数を書いている最中、**カーソル位置の引数がハイライトされた**シグネチャがフロート表示される。

- `vim.lsp.buf.signature_help()`（`gK`）の自動表示版。手動で呼び出さなくても、引数を打つたびに常に最新が出る
- 現在の引数が太字になるので、長い引数リスト（TS / Python）で特に効く
- `border = "rounded"`、カーソル行の上に出る設定（`floating_window_above_cur_line = true`）

### Mason (LSP/ツールのインストーラー)

`:Mason` コマンドで管理画面を開ける。自動インストールされるツール：

- stylua, selene, luacheck（Lua）
- shellcheck, shfmt（シェルスクリプト）
- tailwindcss-language-server, typescript-language-server, css-lsp

---

## 補完 (blink.cmp)

LazyVim デフォルトの nvim-cmp ではなく blink.cmp を使用。高速でモダンな補完エンジン。

### 補完ソースの優先順位

1. **LSP** (最優先) — 型情報・関数・変数
2. **Copilot** (AI サジェスト) — blink-cmp-copilot 経由
3. **Path** (ファイルパス) — `./` や `../` で発火
4. **Snippets** (コードスニペット) — friendly-snippets ライブラリ
5. **Buffer** (バッファ内の単語) — 現在開いているファイルの単語

### 基本操作

| キー | 動作 |
|------|------|
| `<C-n>` / `<C-p>` | 次/前の候補 |
| `<C-y>` / `<CR>` | 候補を確定 |
| `<C-e>` | 補完をキャンセル |
| `<C-Space>` | 手動で補完を開く |
| `<Tab>` / `<S-Tab>` | スニペットのジャンプ |

---

## AI アシスタント (Copilot)

### Copilot の仕組み

**copilot.lua** がバックエンドエンジン。インラインサジェストは無効化されており、
代わりに **blink.cmp** の補完ソースとして統合されている。
つまり補完メニューに Copilot の候補が他の LSP 候補と一緒に表示される。

### Copilot Chat (CopilotChat.nvim)

| キー | 動作 |
|------|------|
| `<Space>aa` | チャットを開く/閉じる |
| `<Space>ae` | クイックチャット（選択範囲またはバッファ全体を送信） |
| `<Space>ax` | チャットをリセット |
| `<Space>aq` | チャットを閉じる |

- モデル: **gpt-4.1**
- ウィンドウ幅: 40%（縦分割）
- ビジュアルモードでコードを選択してから `<Space>ae` でそのコードについて質問できる

---

## Git 操作

### Neovim 内 (git.nvim)

| キー | 動作 |
|------|------|
| `<Space>gb` | Git Blame（現在行のコミット情報） |
| `<Space>go` | ブラウザで GitHub を開く |

### Gitsigns (変更箇所のナビゲーション)

| キー | 動作 |
|------|------|
| `]h` / `[h` | 次/前の変更箇所へジャンプ |
| 行番号横のマーク | 追加（緑）/ 変更（青）/ 削除（赤）を表示 |

### diffview.nvim（PR レビュー用 Git UI）

コミット間 / ブランチ間の**全ファイル差分**を Neovim 内に開く。PR レビューが Neovim で完結する。

| キー | 動作 |
|------|------|
| `<Space>gd` | `:DiffviewOpen`（作業ツリーの差分を開く） |
| `<Space>gh` | 現在ファイルのコミット履歴 |
| `<Space>gH` | リポジトリ全体のコミット履歴 |

```vim
:DiffviewOpen origin/main      " main との差分を全部見る
:DiffviewOpen HEAD~3           " 3 コミット前との差分
:DiffviewClose                 " 閉じる
:DiffviewFileHistory %         " 現在ファイルの全履歴（GitHub Blame ビュー相当）
```

### lazygit（ターミナル TUI）

プロジェクトディレクトリで `lazygit` と打つだけで起動。差分確認・ステージ・コミットが爆速。

```bash
lazygit
```

| キー | 動作 |
|------|------|
| `Space` | ファイルをステージ/アンステージ |
| `c` | コミット |
| `p` / `P` | pull / push |
| `Enter` | ファイルの差分を表示 |
| `[` / `]` | コミット間を移動 |
| `s` | スタッシュ |
| `b` | ブランチパネルへ |
| `n` | 新規ブランチ作成 |
| `?` | キーバインド一覧 |

---

## UI プラグイン

### noice.nvim (モダン UI)

コマンドライン・メッセージ・通知を置き換えるプラグイン。

- コマンドラインがエディタ中央にポップアップ表示
- LSP のホバードキュメントにボーダーを表示
- 通知は nvim-notify 経由（タイムアウト 5 秒）

> **注意**: noice.nvim はホバーウィンドウ内で `K` をリンク操作用にマップする。
> そのため `lua/config/unmap_lsp_k.lua` で上書きが必要。

### bufferline.nvim (タブバー)

画面上部にタブバーを表示。**バッファモードではなくタブモード**で動作。

| キー | 動作 |
|------|------|
| `<Tab>` | 次のタブ |
| `<S-Tab>` | 前のタブ |
| `te` | 新しいタブ |

### lualine.nvim (ステータスライン)

画面下部のステータスライン。ファイルパス（相対/絶対）をカスタム表示。

### incline.nvim (ウィンドウ名)

各ウィンドウの右上にファイル名を表示するフローティングラベル。
カラーは solarized-osaka の magenta/violet を使用。

### snacks.nvim (ダッシュボード)

起動時に **Code Craft** ロゴのダッシュボードを表示。

### render-markdown.nvim（Markdown インライン整形）

Markdown ファイルを開いた瞬間、**編集中のバッファ内**で見出し・リスト・コードブロックが装飾表示される。
Obsidian / Logseq に近い見た目。プレビュー別ウィンドウは不要。

- 見出し: `◉ ○ ✸ ✿`（h1〜h4）
- リスト: `● ○ ◆ ◇`
- コードブロック: ブロック表示（左パディング 2 / 右パディング 4）
- `ft = "markdown"` で起動するので Markdown を開かない限りロードされない

### zen-mode.nvim (集中モード)

```
<Space>z → 余計なUIを消してコードに集中
```

gitsigns と tmux とも連携（zen モード中は tmux のステータスバーも非表示に）。

### Which Key

キーを押して少し待つと、続くキーバインドの候補が表示される。
`<Space>` を押して待てば全コマンドが見られる。

---

## 編集支援プラグイン

### dial.nvim (数値・値の増減)

`+` / `-` で様々な値をインクリメント/デクリメント：

| 対象 | 例 |
|------|------|
| 数値 | `42` → `43` |
| 16進数 | `0xff` → `0x100` |
| 日付 | `2026/04/11` → `2026/04/12` |
| 真偽値 | `true` ↔ `false` |
| セマンティックバージョン | `1.2.3` → `1.2.4` |
| let/const | `let` ↔ `const` |

### mini.pairs (自動括弧)

`(`, `{`, `[`, `"`, `'` を入力すると自動で閉じ括弧が挿入される。

### mini.ai (テキストオブジェクト拡張)

`a` (around) / `i` (inside) に追加のテキストオブジェクトを提供。

### mini.bracketed (角括弧ナビゲーション)

`[` / `]` + キーで様々な要素間を移動：ファイル、ウィンドウ、quickfix、ヤンク、treesitter ノードなど。

### nvim-ts-autotag (自動タグ)

HTML/JSX で開きタグを入力すると閉じタグが自動挿入。タグ名変更時に閉じタグも連動。

### inc-rename.nvim (インクリメンタルリネーム)

`<Space>cr` でリネーム。入力中にバッファ内のすべての参照がリアルタイムでプレビュー変更される。

### mini.move（行・選択ブロックの移動）

VSCode の `Alt+↑↓` 相当。Neovim でもキー 1 つで行・選択ブロックを動かせる。

| キー | モード | 動作 |
|------|------|------|
| `Alt + j` / `Alt + k` | n / x | 行（または選択ブロック）を下 / 上に移動 |
| `Alt + h` / `Alt + l` | x | 選択ブロックを左 / 右に移動 |

リファクタ時、「この 4 行を関数の前に出したい」が秒で終わる。

> ターミナル側で `Alt` キーが奪われていると効かないことがあります（kitty / Alacritty / WezTerm はデフォルトで OK）。

### Treesitter

構文解析エンジン。シンタックスハイライト・テキストオブジェクト・折りたたみなどの基盤。
以下の言語パーサーがインストール済み：

astro, cmake, cpp, css, fish, gitignore, go, graphql, http, java, php, rust, scss, sql, svelte, markdown (MDX 含む)

---

## Vim 矯正ギプス (hardtime / precognition)

「LazyVim をなんとなく使っている」状態から、**Vim 本来のモーションを身体に入れる**ためのトレーニング系プラグイン。
2 つセットで使うのが鉄板。

### hardtime.nvim（悪い癖の警告）

`hjkl` の 3 回以上連打を検知すると「もっと効率的なキーがあるよ」とヒントを出す。

| 設定 | 値 |
|---|---|
| `max_count` | `3`（連打許容回数） |
| `restriction_mode` | `"hint"`（警告のみ。`"block"` にすると即停止） |
| `disable_mouse` | `false`（マウスは無効化しない） |

最初は鬱陶しいが、2 週間で `5j` `}` `gg` `<C-d>` などの効率的な移動が体に染み込む。
中級者になったら `restriction_mode = "block"` に上げると効果絶大。

### precognition.nvim（モーション提案の常時表示）

カーソル位置から「次にどう動けるか（`w` `b` `e` `^` `$` ...）」を画面上に常時表示する。

- `startVisible = true`：起動時から表示
- 鬱陶しくなったら `startVisible = false` に変更し、`:Precognition toggle` で必要時だけ表示
- hardtime と組み合わせるのが効果的：
  - **precognition** = 「どこに飛べるかを教える」
  - **hardtime** = 「飛ばないことを警告する」
  - → vim 言語が体に入る最短経路

---

## 便利機能

### カラーコード変換

```
<Space>r → 現在行の Hex カラーを HSL に変換
```

mini.hipatterns により、コード中の `hsl(210, 50%, 60%)` のような値が実際の色でハイライトされる。

### TODO ハイライト (todo-comments.nvim)

コメント中の `TODO:` `FIXME:` `HACK:` `NOTE:` が自動でハイライトされ、Telescope で一覧検索も可能。

### grug-far（検索・置換）

プロジェクト全体の検索・置換。`<Space>sr` で起動、`<Space>sw` でカーソル下の単語をプリフィル起動。
詳細は [検索・置換テクニック](#検索置換テクニック) を参照。

### Trouble（診断一覧）

```
<Space>xx → 診断一覧を開く
<Space>xX → バッファ内の診断のみ
```

### persistence.nvim（セッション管理）

Neovim を閉じても、次回同じディレクトリで開けば前回のセッション（開いていたファイル・ウィンドウ配置）を復元できる。

---

## 対応言語

| 言語 | LSP | フォーマッター | 備考 |
|------|-----|------------|------|
| TypeScript/JS | tsserver | Prettier | インレイヒント対応 |
| HTML | html | Prettier | 自動タグ閉じ (autotag) |
| CSS | cssls | Prettier | |
| Tailwind | tailwindcss | - | クラス補完 |
| JSON | jsonls | Prettier | SchemaStore対応 |
| PHP | intelephense | php-cs-fixer | K&Rスタイル |
| Rust | rust-analyzer | rustfmt | rustaceanvim 拡張 |
| Lua | lua_ls | stylua | インレイヒント対応 |
| YAML | yamlls | - | |
| Astro/Svelte | Treesitter | Prettier | |
| Go/C++/Java | Treesitter | - | シンタックスのみ |

---

## 日常ワークフロー例

### 1. ファイルを開いてコードを書く

```
;f → ファイル名の一部を入力 → Enter で開く
→ コードを書く（blink.cmp が自動補完）
→ 保存 (:w) で自動フォーマット
```

### 2. エラーを修正する

```
<Space>xx → Trouble でエラー一覧を確認
<C-j> → 次のエラーへジャンプ
<Space>h → ホバーで詳細確認
<Space>ca → コードアクションで自動修正
```

### 3. リファクタリング

```
gd → 定義にジャンプして確認
<Space>cr → リネーム（プロジェクト全体に反映）
;r → grep で関連箇所を確認
```

### 4. コードレビュー

```
<Space>gb → git blame で変更者を確認
<Space>go → GitHub で該当箇所を開く
]h / [h → 変更箇所を巡回
```

### 5. AI に相談

```
（コードをビジュアルモードで選択）
<Space>ae → "このコードを最適化して" と入力
```

---

## エラー・ログ調査ツール

Neovim の外で使うターミナルツール。`<C-/>` で Neovim 内ターミナルを開けるので、画面を離れずに使える。

### lnav - ログビューア

`tail -f` の上位互換。ログファイルをリアルタイム追跡し、色付き・構造化表示してくれる。

```bash
# 基本：ログファイルを開く
lnav /var/log/system.log

# 複数ファイルを同時に追跡
lnav app.log error.log

# ワイルドカードで一括
lnav logs/*.log

# フィルタ付きで起動（errorだけ表示）
lnav -c ':filter-in error' app.log
```

#### lnav 内の操作

| キー | 動作 |
|------|------|
| `/` | 検索 |
| `n` / `N` | 次/前の検索結果 |
| `e` / `E` | 次/前のエラー行へジャンプ |
| `w` / `W` | 次/前の警告行へジャンプ |
| `Tab` | ファイル切り替え（複数ファイル時） |
| `i` | ヒストグラム表示（時間帯ごとのログ量） |
| `:filter-in <pattern>` | パターンに一致する行だけ表示 |
| `:filter-out <pattern>` | パターンに一致する行を除外 |
| `:reset-session` | フィルタをリセット |

#### lnav の SQL モード

lnav は内部で SQLite を使っており、ログに対して SQL を実行できる：

```bash
# lnav 内で ; を押してSQLモードに入る
;SELECT log_time, log_body FROM syslog_log WHERE log_body LIKE '%error%' ORDER BY log_time DESC LIMIT 20

# レベル別の件数を集計
;SELECT log_level, COUNT(*) as cnt FROM syslog_log GROUP BY log_level

# 特定時間帯のログを抽出
;SELECT * FROM syslog_log WHERE log_time > '2026-04-11 10:00:00'
```

### jq - JSON ログのパース

構造化ログ（JSON Lines 形式）を扱うときの必須ツール。

```bash
# JSON ログの整形表示
cat app.log | jq '.'

# 特定フィールドだけ抽出
cat app.log | jq '{time: .timestamp, msg: .message, level: .level}'

# エラーだけフィルタ
cat app.log | jq 'select(.level == "error")'

# リアルタイムでフィルタ（tail -f と組み合わせ）
tail -f app.log | jq 'select(.level == "error") | {time: .timestamp, msg: .message}'

# ユニークなエラーメッセージを集計
cat app.log | jq -r 'select(.level == "error") | .message' | sort | uniq -c | sort -rn
```

### rg (ripgrep) - 高速テキスト検索

Telescope の `;r` の裏側で動いているツール。ターミナルで直接使うと大量ファイルの検索に強い。

```bash
# 基本：エラーを検索
rg 'ERROR' logs/

# 前後の行も表示（コンテキスト）
rg 'ERROR' -C 3 logs/

# 特定の拡張子だけ
rg 'throw' --type ts

# 特定のファイルを除外
rg 'TODO' --glob '!node_modules' --glob '!*.min.js'
```

### 組み合わせパターン

```bash
# rg で見つけたファイルを lnav で開く
rg -l 'FATAL' logs/ | xargs lnav

# rg で JSON ログからエラーを抽出し jq で整形
rg --no-filename '"level":"error"' logs/*.json | jq '{time: .timestamp, msg: .message}'

# Docker コンテナのログを jq で解析
docker logs myapp 2>&1 | jq 'select(.level == "error") | .message'
```

### Neovim との連携

```
# Neovim 内ターミナル（<C-/>）で直接実行できる
# 調査結果を見つけたら <C-/> で戻ってコードを修正

# もう一つの方法：Neovim で直接ログファイルを開く
:e /path/to/app.log
;r でログ内を検索（Telescope grep）
```

---

## カスタマイズの仕組み

### ディレクトリ構造

```
~/.config/nvim/
├── init.lua                  # エントリポイント（lazy.nvim の読み込み等）
├── lua/
│   ├── config/
│   │   ├── lazy.lua          # lazy.nvim の設定（LazyVim extras の選択）
│   │   ├── keymaps.lua       # グローバルキーマップ
│   │   ├── options.lua       # Neovim オプション
│   │   ├── autocmds.lua      # 自動コマンド
│   │   └── unmap_lsp_k.lua   # K → 10k の上書き処理
│   ├── plugins/              # プラグイン設定（lazy.nvim が自動読み込み）
│   │   ├── lsp.lua           # LSP サーバー・Mason 設定
│   │   ├── editor.lua        # 編集系プラグイン
│   │   ├── ui.lua            # UI 系プラグイン
│   │   ├── treesitter.lua    # Treesitter 設定
│   │   ├── telescope.lua     # Telescope 設定
│   │   ├── copilot.lua       # Copilot 設定
│   │   ├── formatting.lua    # conform.nvim 設定
│   │   └── ...
│   └── craftzdog/            # ユーティリティモジュール
│       ├── lsp.lua           # toggleInlayHints, toggleAutoformat
│       └── hsl.lua           # Hex → HSL 変換
└── lazy-lock.json            # プラグインのバージョンロック
```

### LazyVim Extras（有効化済み）

`lua/config/lazy.lua` で以下の extras を有効化：

- `lazyvim.plugins.extras.linting.eslint` — ESLint 統合
- `lazyvim.plugins.extras.formatting.prettier` — Prettier 統合
- `lazyvim.plugins.extras.lang.typescript` — TypeScript 支援
- `lazyvim.plugins.extras.lang.json` — JSON スキーマ補完
- `lazyvim.plugins.extras.lang.rust` — Rust (rustaceanvim)
- `lazyvim.plugins.extras.lang.tailwind` — Tailwind CSS
- `lazyvim.plugins.extras.ui.mini-hipatterns` — カラーハイライト

### プラグインの追加・変更方法

`lua/plugins/` に新しい `.lua` ファイルを作るか、既存ファイルに追加する。
lazy.nvim が自動で読み込む。

```lua
-- lua/plugins/example.lua
return {
  {
    "author/plugin-name",
    opts = { ... },
  },
}
```

LazyVim のデフォルトを上書きするには、同じプラグイン名で設定を書く。
`opts` を関数にすると既存の設定をマージできる：

```lua
{
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
      -- 追加の LSP サーバー設定
    })
    return opts
  end,
}
```

### 無効化されているプラグイン

- `mini-files` — ファイルエクスプローラー（Oil.nvim を使用）
- `project` — プロジェクト管理
- `yanky` — ヤンク拡張
- `nvim-dap` — デバッガー

### 2026 年トレンド取り込みで追加したプラグイン

[codecraft1129.com の LazyVim 厳選 17 選](https://codecraft1129.com/posts/lazyvim-essential-plugins-curated-2026/)を参考に、案 A（軽量スタート）として導入：

| プラグイン | 役割 | キー |
|---|---|---|
| `flash.nvim`（再有効化） | 2 文字ジャンプ + Treesitter ノード選択 | `s` / `S` / `r` |
| `harpoon` (v2) | 4 ファイル即切替 | `<Space>ha` / `<Space>hh` / `<Space>1〜4` |
| `mini.move` | 行・選択ブロック移動 | `Alt + h/j/k/l` |
| `nvim-ufo` | Treesitter ベースの折りたたみ | `zR` / `zM` |
| `lsp_signature.nvim` | 関数引数の自動シグネチャ | InsertEnter で自動表示 |
| `hardtime.nvim` | hjkl 連打警告（hint モード） | 自動 |
| `precognition.nvim` | モーション提案の常時表示 | `:Precognition toggle` |
| `diffview.nvim` | PR レビュー用 git UI | `<Space>gd` / `<Space>gh` / `<Space>gH` |
| `render-markdown.nvim`（再有効化） | Markdown インライン装飾 | Markdown ファイルを開くだけ |

> AI 系（avante / codecompanion）は CopilotChat と被るためスキップ。
> Neogit も lazygit と被るためスキップ。
