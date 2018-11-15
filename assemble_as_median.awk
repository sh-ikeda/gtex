### 組織、性別、年齢ごとに、値を median でまとめる。

BEGIN {
    OFS = "\t"
    FS = "\t"
}

FNR<=5&&FNR>=3 { # 3 行目が組織小分類。4 行目が性別。5 行目が年齢。
    for(i=3; i<=NF; i++) {
        row[FNR, i] = $i
        name[i] = name[i] $i
    }
}

FNR==5 { # 6 に入る前
    sep[1] = 3 # 3 列目から１つ目の区切りが始まる
    nsep=2
    prev = name[3]
    for(i=4; i<=NF; i++) {
        if(name[i]!=prev) {
            sep[nsep] = i
            nsep++
        }
        prev = name[i]
    }
    sep[nsep] = NF+1
    printf "id\tDescription"
    for(k=3; k<=5; k++){
        for(j=1; j<nsep; j++)
            printf "\t" row[k, sep[j]]
        printf "\n"
        if(k!=5)
            printf "\t"
    }
}

FNR>=6 {
    printf $1 "\t" $2
    for(j=1; j<nsep; j++) {
        for(i=sep[j]; i<sep[j+1]; i++)
            tpm[i-sep[j]+1] = $i
        n=asort(tpm, result)

        if(n%2==0)
            med = (result[n/2]+result[1+n/2])/2
        else
            med = result[(n+1)/2]
        delete(tpm)
        printf "\t" med
    }
    printf "\n"
}

END {
    
}
