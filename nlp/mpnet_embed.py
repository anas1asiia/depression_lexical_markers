# -*- coding: utf-8 -*-
"""
mpnet_embed.py
Spyder Editor

This script extracts dense vector embeddings using the multilingual MPNet model
(available at Hugging Face) with 768 dimensions.

- Input: A CSV file with a column named 'Text'
- Output: A CSV file with 768 MPNet embedding features appended per row

Author: Anastasiia Tokareva
Project: Multilingual Lexical Markers and Text Embedding Prediction of Depression Symptom Severity
"""


# reset my workspace

from IPython import get_ipython
get_ipython().run_line_magic('reset', '-sf')


## 1. Import the necessary libraries

# import math
import pandas as pd
# from datetime import datetime

import torch
device = "cuda:0" if torch.cuda.is_available() else "cpu"

# suppress warnings for cleaner output
import warnings
warnings.filterwarnings("ignore")


## 2. Import Hugging Face model and test it out on sample sentences

from sentence_transformers import SentenceTransformer
sentences = ["This is an example sentence", "Each sentence is converted"]

model = SentenceTransformer('sentence-transformers/paraphrase-multilingual-mpnet-base-v2')
embeddings = model.encode(sentences)
print(embeddings)


## 3. Extract vector embeddings from the target text (e.g., RADAR-MDD with 'Text' column)

# import sys
# sys.path.append('C:/Users/your/file/path/here')

df_embeddings = pd.DataFrame(columns=[])
df_data = pd.read_csv('C:/Users/your/file/path/here')

# generate columns starting with MPNet
name = 'Mpnet_'
name_list = []


for i in range(1, 769):  # 768 dimensions in MPNET model
    updated_name = name + str(i)
    name_list.append(updated_name)
    
for index_SD, row_SD in df_data.iterrows():
    
        sentence = row_SD['Text']
        
        if isinstance(sentence, str):
            row_SD = row_SD.drop(labels=['Text'])
            
            embeddings = pd.Series(model.encode(sentence))
            embeddings.index = name_list
            embeddings = pd.concat([row_SD, embeddings])
            
            df_embeddings = pd.concat([df_embeddings,embeddings.to_frame().T], ignore_index=True)
    

# save the file
df_embeddings.to_csv("C:/Users/your/desired/file/name.csv", index=False, na_rep='NaN')








