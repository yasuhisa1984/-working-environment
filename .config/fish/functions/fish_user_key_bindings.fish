function fish_user_key_bindings
    # fzf
    bind \cf fzf_change_directory

    # vim-like
    bind \cl forward-char

    # prevent iterm2 from closing when typing Ctrl-D (EOF)
    bind \cd delete-char

    # fssh を Ctrl+S に割り当て
    bind \cs fssh
end

# fzf plugin
fzf_configure_bindings --directory=\co

# fzf plugin（fzf.fish が導入済みの場合のみ実行）
if functions -q fzf_configure_bindings
    fzf_configure_bindings --directory=\co
end
