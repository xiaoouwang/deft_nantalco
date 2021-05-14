# This script takes question and response files, clean and merge to one

# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
from utils_xo import *
import re
import pandas as pd

path_q = "Train/T2/trainT2-Q.tab"
path_r = "Train/T2/trainT2-R.tab"


# %%
# done, - need new responses column because multiple responses possible


# %%
df_question = pd.read_csv(path_q, sep="\t", header=None)
df_question = df_question.drop(df_question.columns[5], axis=1)
df_question.columns = ['numeroQ', 'noteMaxOri',
                       'nomQ', 'texteQuestion', 'EltCorrections']
df_question.texteQuestion = df_question.texteQuestion.apply(
    html_cleaning).apply(lambda x: x.strip())
df_question.EltCorrections = df_question.EltCorrections.apply(
    html_cleaning).apply(lambda x: x.strip())


# %%

xo_write_json_fromdf("q.json", df_question)


# %%
# see the other dataframe
# ok
df_reponse = pd.read_csv(path_r, sep="\t", header=None)
df_reponse.columns = ['numeroQ', 'noteObtenue', 'nomE', 'texteRep']
df_reponse.texteRep = df_reponse.texteRep.apply(lambda x: x.replace("\\n", "").strip()).apply(html_cleaning)
df_reponse.texteRep
# df_reponse.texteRep.apply(html_cleaning).apply(lambda x:x.strip().replace("\\n",""))


# %%
xo_write_json_fromdf("r.json", df_reponse)


# %%
# merge the two

# @ make sure that question ids match
question_id1 = sorted(list(dict(df_reponse.numeroQ.value_counts()).keys()))
question_id2 = sorted(list(dict(df_question.numeroQ.value_counts()).keys()))
assert question_id2 == question_id1


# %%
# @ merge two df using dict
df2 = xo_read_json("r.json")
df1 = xo_read_json("q.json")
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
