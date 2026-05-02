if type -q eza
  alias ll "eza -l -g --icons"
  alias lla "ll -a"
end

# Tmuxinator
if type -q tmuxinator
  alias mux 'tmuxinator'
end

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
