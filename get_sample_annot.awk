### 発現量データのサンプル名の行の下に、必要なアノテーション(組織名)を取り込む

BEGIN {
    OFS = "\t"
    FS = "\t"
}

FNR==NR {
    smts[$1] = $6
    smtsd[$1] = $7
}

FNR!=NR {
    if(FNR==3) {
        for(i=1; i<=NF; i++) {
            row2[i] = smts[$i]
            row3[i] = smtsd[$i]
        }
        print $0
        printf row2[1] "\t"
        for(i=2; i<=NF; i++) {
            printf "\t" row2[i]
        }
        printf "\n" row3[1] "\t"
        for(i=2; i<=NF; i++) {
            printf "\t" row3[i]
        }
        printf "\n"
    }
    else if(FNR>=4)
        print
}
