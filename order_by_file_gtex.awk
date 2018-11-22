### １つ目のファイルは２つ目のファイルのカラムを表示する順番を表す

BEGIN {
    OFS = "\t"
    FS = "\t"
    n = 1
}

FNR==NR && $0!="" {
    order[n] = 1+$1 # python で出力しているので 0 origin になっている。1 足して補正
    n++
}

FNR!=NR {
    printf $1
    for(i=1; i<n; i++)
        printf "\t" $order[i]
    printf "\n"
}
