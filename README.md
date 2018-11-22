# GTEx の発現量データを RefEx に収載する
## ファイルのダウンロード
- GTEx の発現量データ (TPM)
  https://storage.googleapis.com/gtex_analysis_v7/rna_seq_data/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct.gz
- サンプルのアノテーション
  https://storage.googleapis.com/gtex_analysis_v7/annotations/GTEx_v7_Annotations_SampleAttributesDS.txt
- 個体のアノテーション
  https://storage.googleapis.com/gtex_analysis_v7/annotations/GTEx_v7_Annotations_SubjectPhenotypesDS.txt
## アノテーション情報の取得
発現量データのサンプル名の行の下に、必要なアノテーション(組織名)を取り込む

$ awk -f get_sample_annot.awk GTEx_v7_Annotations_SampleAttributesDS.txt GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct > gtex_all_sample_tpm.tsv

4, 5 行目に性別、年齢を持つよう、個体のアノテーションファイルを使って gtex_all_sample_tpm.tsv を修正

$ awk -f get_sbj_annot.awk GTEx_v7_Annotations_SubjectPhenotypesDS.txt gtex_all_sample_tpm.tsv > temp.txt

$ mv temp.txt gtex_all_sample_tpm.tsv
## 性別、年齢、組織ごとに発現量をまとめる
4 列目が性別、5 列目が年齢、3 列目が組織となっているので、その優先順でソートする  
python で行うが、pandas の read_table だと 3 G 近くあるファイルを読み込むだけでもかなりの時間がかかる。  
そこで、ソートのキーであるヘッダ部分のみのファイルを作ってソートし、to_csv のオプションを header=True として出力する。

$ head -5 gtex_all_sample_tpm.tsv > gtex_header.tsv

$ python sort_columns_gtex.py gtex_header.tsv gtex_header_sorted.tsv

読み込み時に header=None としているので、データフレームの header には 0 から始まる数値が順に付けられている。
これのソート後の順番が１行目に header として出力されるので、この部分を読み込んで、元のファイルをこの数値の順に出力することで時間を抑える。

$ head -1 gtex_header_sorted.tsv > gtex_order.tsv

$ awk -f order_by_file_gtex.awk order.txt gtex_all_sample_tpm.tsv > gtex_all_sample_tpm_sorted.tsv


組織、性別、年齢ごとに、値を median でまとめる

$ awk -f assemble_as_median.awk gtex_all_sample_tpm_sorted.tsv > gtex_grouped_tpm.tsv

TPM の値を log2 に変換する  
0 もあるので、全部の値に 1 を足してから変換する

$ awk -F "\t" 'FNR<=3{print} FNR>=4{printf $1 "\t" $2; for(i=3; i<=NF; i++) {printf "\t" log(1+$i)/log(2);} printf "\n"}' gtex_grouped_tpm.tsv > gtex_grouped_log2_tpm.tsv
