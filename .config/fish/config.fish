set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias c claude
command -qv nvim && alias vim nvim

# GUI apps
alias code='open -a "Visual Studio Code"'
alias finder='open .'
alias db='open -a "TablePlus"'

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end
set -gx PATH /opt/homebrew/bin /usr/local/bin $PATH

set -x NVM_DIR $HOME/.nvm
bass source $NVM_DIR/nvm.sh --no-use ';' nvm use default

# Auto-launch zellij on iTerm2
if status is-interactive; and not set -q ZELLIJ
    # Check if running in iTerm2
    if test -n "$ITERM_SESSION_ID"
        zellij
    end
end

function __wezterm_cwd --on-variable PWD
    printf "\e]7;file://%s%s\e\\" (hostname) $PWD
end
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
