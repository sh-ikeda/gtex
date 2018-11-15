# gtex
Process GTEx data for importing to RefEx
GTEx のデータを RefEx にインポートできるようにする
- GTEx の発現量データ (TPM)
  https://storage.googleapis.com/gtex_analysis_v7/rna_seq_data/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct.gz
- サンプルのアノテーション
  https://storage.googleapis.com/gtex_analysis_v7/annotations/GTEx_v7_Annotations_SampleAttributesDS.txt
- 個体のアノテーション
  https://storage.googleapis.com/gtex_analysis_v7/annotations/GTEx_v7_Annotations_SubjectPhenotypesDS.txt

発現量データのサンプル名の行の下に、必要なアノテーション(組織名)を取り込む

$ awk -f get_sample_annot.awk GTEx_v7_Annotations_SampleAttributesDS.txt GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct > gtex_all_sample_tpm.tsv

4, 5 行目に性別、年齢を持つよう、個体のアノテーションファイルを使って gtex_all_sample_tpm.tsv を修正

$ awk -f get_sbj_annot.awk GTEx_v7_Annotations_SubjectPhenotypesDS.txt gtex_all_sample_tpm.tsv > temp.txt
$ mv temp.txt gtex_all_sample_tpm.tsv

sort コマンドが列方向のソートをできないようなので、転置してからソート
transpose コマンド (http://downloads.sourceforge.net/project/transpose/transpose/transpose-2.0/2.0/transpose-2.0.zip) はデフォルトだと 1000x1000 までしか転置せず、それ以上のサイズを取り扱いたい場合は -i オプションでサイズを指定する必要がある

$ head -1 gtex_all_sample_tpm.tsv | awk -F "\t" '{print NF}'
11690

$ wc -l gtex_all_sample_tpm.tsv
56207 gtex_all_sample_tpm.tsv

$ transpose.exe -i 56207x11690 -t gtex_all_sample_tpm.tsv > gtex_all_sample_tpm_transposed.txt

4 列目が性別、5 列目が年齢、3 列目が組織となっているので、その優先順でソートしたあと、再度行列を転置する

$ sort -t$'\t' -k 4,4 -k 5,5 -k 3,3 gtex_all_sample_tpm_transposed.txt > gtex_all_sample_tpm_transposed_sorted.txt

$ transpose.exe -i 11690x56207 -t gtex_all_sample_tpm_transposed_sorted.txt > gtex_all_sample_tpm_sorted.tsv

組織、性別、年齢ごとに、値を median でまとめる

$ awk -f assemble_as_median.awk gtex_all_sample_tpm_sorted.tsv > gtex_grouped_tpm.tsv
