# ブランチ/タグをfzfで選択して git checkout する
# 依存: fzf, git
function gcof
    # -l はローカル変数、() はコマンド置換（Fishでは空白区切りで配列化される点に注意）
    set -l branches (begin; git branch -a; and git tag; end)

    # 候補が無ければ終了
    if test (count $branches) -eq 0
        echo "No branches or tags found."
        return 1
    end

    # fzfに改めて改行区切りで渡す（printfを使って安全に改行出力）
    set -l branch (printf "%s\n" $branches | fzf +m)

    # 何も選ばなければ終了
    if test -z "$branch"
        return 0
    end

    # 先頭の「* 」を除去（現在ブランチ表示対策）、"remotes/" 接頭辞も除去して実ブランチ名に
    set -l target (string replace -r '^\* ' '' -- $branch)
    set target (string replace -r '^remotes/' '' -- $target)

    # 念のため前後の空白をトリム
    set target (string trim -- $target)

    # チェックアウト実行
    echo "git checkout $target"
    git checkout $target
end
