# -*- coding: utf-8 -*-

import pandas as pd
import os 
import subprocess

files = [x for x in os.listdir() if x.endswith('.json')]
for file in files: 
    reader = pd.read_json(file, lines=True, chunksize=100000)   
    file_no = 1
    header=True
    filename = f'converted/{file.split(".")[0]}.csv'
    open(filename, 'a').close()
    
    for chunk in reader:
        print(f'converting file {file} chunk # {file_no}...')
        print(chunk.shape[0])
        chunk = chunk.replace(regex=r'\n', value=' ')
        chunk.to_csv(filename, header=header, index=False, mode='a', sep=';', escapechar='\\')
        file_no += 1
        header=False
        