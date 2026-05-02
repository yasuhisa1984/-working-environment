# tmuxinator config

プロジェクトごとに tmux セッションを 1 コマンドで立ち上げるための設定。

## 構成

```
.config/tmuxinator/
├── README.md                          # このファイル
├── sample-local-project.yml.example   # ローカルプロジェクト用テンプレ（公開）
├── sample-ssh-remote.yml.example      # SSH リモート開発用テンプレ（公開）
└── *.yml                              # 個別プロジェクト（.gitignore で除外）
```

実プロジェクトの `*.yml` はクライアント名や内部パスを含むため `.gitignore` で git 管理外にしている。テンプレ (`*.yml.example`) のみが公開される。

## 前提インストール

```sh
brew install tmuxinator
# Linux: gem install tmuxinator
```

## セットアップ手順（新規マシン）

1. **dotfiles を clone**
   ```sh
   ghq get yasuhisa1984/-working-environment
   ```

2. **既存の `~/.config/tmuxinator` を退避（あれば）**
   ```sh
   mv ~/.config/tmuxinator ~/.config/tmuxinator.bak 2>/dev/null
   ```

3. **dotfiles の tmuxinator ディレクトリへ symlink**
   ```sh
   ln -s ~/ghq/github.com/yasuhisa1984/-working-environment/.config/tmuxinator ~/.config/tmuxinator
   ```

4. **動作確認**
   ```sh
   tmuxinator list
   ```

## 新規プロジェクトを追加する

1. テンプレをコピー
   ```sh
   cd ~/.config/tmuxinator
   cp sample-local-project.yml.example my-new-project.yml
   ```
2. `name` と `root`、各 window のパスを書き換え
3. 起動
   ```sh
   tmuxinator start my-new-project
   # または短縮形
   mux my-new-project
   ```

新規 `.yml` は `.gitignore` 対象なので、間違えてクライアント名を commit する心配はない。

## 公開したい設定がある場合

汎用的な構成で他人にも参考になりそうな設定なら、`*.yml.example` 拡張子で保存すれば git に含まれる：

```sh
cp my-template.yml my-template.yml.example
git add my-template.yml.example
```

## よく使うコマンド

| コマンド | 動作 |
|---|---|
| `tmuxinator start <name>` / `mux <name>` | プロジェクト起動 |
| `tmuxinator list` / `mux list` | 設定一覧 |
| `tmuxinator edit <name>` | 設定編集（$EDITOR で開く） |
| `tmuxinator stop <name>` | セッション終了 |
| `tmuxinator copy <src> <dst>` | 設定複製 |

## tmux 内のキー操作

`Prefix` は `tmux.conf` の設定に従う（デフォルト `<C-b>`、隊長環境は `tmux.conf` 参照）。

| キー | 動作 |
|---|---|
| `Prefix` + 数字 | window 切替（1, 2, ...） |
| `Prefix` + `n` / `p` | 次 / 前の window |
| `Prefix` + `o` | 次の pane |
| `Prefix` + `z` | pane を最大化トグル |
| `Prefix` + `d` | セッションをデタッチ |
