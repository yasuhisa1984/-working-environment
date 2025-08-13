# ~/.ssh/config の Host エントリからfzfで選んで ssh 接続
# 依存: fzf, grep, awk, ssh
function fssh
    # "Host *" のワイルドカードは除外し、2列目のホスト名だけを抽出
    # macOSのgrep( BSD )は先読みが弱いので、awkで "* 以外" を弾く
    set -l host (grep -E '^[Hh]ost[[:space:]]+' ~/.ssh/config \
    | awk '$2 != "*" {print $2}' \
    | fzf)

    if test -z "$host"
        echo "No host selected."
        return 0
    end

    echo "ssh $host"
    ssh "$host"
end
