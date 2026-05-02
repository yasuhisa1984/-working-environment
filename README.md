# My dotfiles

個人開発環境用の dotfiles。macOS / Linux / Windows で共有して使う。

> **Warning**: 個人設定なのでそのまま流用するのは推奨しません。参考程度に。

## 構成

- **Neovim** — LazyVim ベース、Code Craft カスタマイズ
- **Fish shell** — Tide テーマ + Fisher プラグイン群
- **tmux + tmuxinator** — プロジェクトごとのセッションテンプレ
- **Git** — alias / hist / hub 連携
- **PowerShell** — Oh My Posh + PSFzf（Windows 用）
- **Ghostty / lazygit / kitty** などのツール設定

詳細な使い方・キーマップは [`.config/nvim/USAGE.md`](./.config/nvim/USAGE.md) を参照。

## Neovim

### Requirements

- Neovim >= **0.9.0**（LuaJIT ビルド）
- Git >= **2.19.0**（partial clones 対応）
- [LazyVim](https://www.lazyvim.org/)
- [Nerd Font](https://www.nerdfonts.com/) v3.0+（一部アイコン表示用）
- [lazygit](https://github.com/jesseduffield/lazygit)（任意）
- C コンパイラ（`nvim-treesitter` 用）
- Telescope 用：[ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd)
- True color + undercurl 対応ターミナル：
  - [kitty](https://github.com/kovidgoyal/kitty), [wezterm](https://github.com/wez/wezterm), [alacritty](https://github.com/alacritty/alacritty), [iTerm2](https://iterm2.com/)
- カラースキーム: [Solarized Osaka](https://github.com/craftzdog/solarized-osaka.nvim)

## Shell setup (macOS / Linux)

- [Fish shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher) — プラグインマネージャ
- [Tide](https://github.com/IlanCosman/tide) — シェルテーマ
- [Nerd fonts](https://github.com/ryanoasis/nerd-fonts)
- [z for fish](https://github.com/jethrokuan/z) — ディレクトリジャンプ
- [Eza](https://github.com/eza-community/eza) — `ls` 置き換え
- [ghq](https://github.com/x-motemen/ghq) — リポジトリオーガナイザ
- [fzf](https://github.com/PatrickF1/fzf.fish) — インタラクティブ絞り込み
- [tmuxinator](https://github.com/tmuxinator/tmuxinator) — tmux セッションテンプレ管理（[使い方](./.config/tmuxinator/README.md)）

## PowerShell setup (Windows)

- [Scoop](https://scoop.sh/)
- [Git for Windows](https://gitforwindows.org/)
- [Oh My Posh](https://ohmyposh.dev/)
- [Terminal Icons](https://github.com/devblackops/Terminal-Icons)
- [PSReadLine](https://docs.microsoft.com/en-us/powershell/module/psreadline/)
- [z](https://www.powershellgallery.com/packages/z)
- [PSFzf](https://github.com/kelleyma49/PSFzf)
