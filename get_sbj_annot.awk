### 発現量データのサンプル名の行の下に、必要なアノテーション(性別、年齢)を取り込む

BEGIN {
    OFS = "\t"
    FS = "\t"
}

FNR==NR {
    if($2==1)
        sex[$1] = "M"
    else
        sex[$1] = "F"
    age[$1] = $3
}

FNR!=NR {
    if(FNR==1) {
        for(i=3; i<=NF; i++) {
            hyphen2 = index(substr($i, 6), "-") + 5
            sbj = substr($i, 1, hyphen2-1)
            row4[i] = sex[sbj]
            row5[i] = age[sbj]
        }
        print $0
    }
    else if(FNR==2){
        print
    }
    else if(FNR==3){
        print
        printf "\t\t" row4[3]
        for(i=4; i<=NF; i++)
            printf "\t" row4[i]
        printf "\n\t\t" row5[3]
        for(i=4; i<=NF; i++)
            printf "\t" row5[i]
        printf "\n"
    }
    else if(FNR>=4){
        print
    }
}
