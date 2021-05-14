from utils_xo import *
import pandas as pd

df1 = xo_read_json("q.json")
df2 = xo_read_json("r.json")
# make id question paires
id_question = {}
id_correction = {}
for k in df1:
    id_question[k["numeroQ"]] = k["texteQuestion"]
    id_correction[k["numeroQ"]] = k["EltCorrections"]

for k in df2:
    k["texteQuestion"] = id_question[k["numeroQ"]]
    k["EltCorrections"] = id_correction[k["numeroQ"]]

# df2

# @ reorder keys
desired_order = ["texteQuestion", "EltCorrections",
                 "texteRep", "noteObtenue", "numeroQ"]

df3 = []
for k in df2:
    output = {b: k[b] for b in desired_order}
    df3.append(output)

xo_write_json_fromlist("train.json", df3)


# %%
# to csv
xo_json2csv("train.json", "train.csv")
