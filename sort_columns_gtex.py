import numpy as np
import pandas as pd
import sys

args = sys.argv
infile = args[1]
outfile = args[2]

a=[0]
a.extend(list(range(2, 11690)))
data = pd.read_table(infile, header=None, index_col=0, sep='\t', dtype = 'object', usecols=a)
print("read table done")
l_index = list(data.index)
l_index[3] = "3"
l_index[4] = "4"
l_index[2] = "2"
data.index = l_index

data_s = data.sort_values([l_index[3], l_index[4], l_index[2]], axis=1)
print("data sort done")
annot = pd.read_table(infile, header=None, index_col=0, sep='\t', dtype = 'object', usecols=[0, 1])
annot.index = l_index
data_c = pd.concat([annot, data_s], axis=1)
l_index[3] = ""
l_index[4] = ""
l_index[2] = ""
data_c.index = l_index
#data_c.to_csv(outfile, sep='\t', na_rep="", header=False)
data_c.to_csv(outfile, sep='\t', na_rep="", header=True)
