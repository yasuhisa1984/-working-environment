# プロセス一覧からfzfで複数選択し、kill -9 する
# 依存: fzf, ps, awk, kill
function kill-process
    # 見やすいようにヘッダ行を落としてfzfへ。複数選択(-m)対応
    set -l pids (ps aux | sed '1d' | fzf -m | awk '{print $2}')

    # 何も選ばれなければ終了
    if test (count $pids) -eq 0
        echo "No process selected."
        return 0
    end

    # 実行前に一応表示
    echo "Killing PIDs: $pids"
    # 注意: 強制終了(-9)。まずは通常のTERMで落としたい場合は -15 に変えるなど調整可
    command kill -9 $pids
end
