# -*- coding: utf-8 -*-

import pandas as pd
import os 
import subprocess

files = [x for x in os.listdir() if x.endswith('.json')]
#files = ['business.json']
for file in files: 
    reader = pd.read_json(file, lines=True, chunksize=100000)   
    file_no = 1
    header=True
    filegroup = []
    for chunk in reader:
        print(f'converting file {file} chunk # {file_no}...')
        print(chunk.shape[0])
        filename = f'converted/{file.split(".")[0]}{file_no:0>2d}.csv'
        chunk.to_csv(filename, header=header)
        file_no += 1
        header=False
        filegroup.append(filename)
    
    # contatenate the chunks    
    outfile = f'converted/{file.split(".")[0]}.csv'
    cmd = 'cat ' + ' '.join(filegroup) + ' > ' + outfile
    subprocess.run(cmd, shell=True)
    
    # delete the fragments
    cmd = 'rm ' + ' '.join(filegroup)
    subprocess.run(cmd, shell=True)
        