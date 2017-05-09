#!/bin/bash

FILES=("Data_Batch1.txt" "Data_Batch1_noisy.txt" "clean_files.zip" "noisy_shuf_files.zip")

for f in ${FILES[*]}
do
    if [ -f "./data/raw/$f" ]
    then
	echo "File '$f' already exists. Not downloading again"
    else
	echo "Downloading '$f'"
	wget -O ./data/raw/$f https://tasoc.dk/download_conference.php?file=TDA2/data/$f
    fi
done

echo "Extracting files"
unzip ./data/raw/clean_files.zip -d ./data/raw/
unzip ./data/raw/noisy_shuf_files.zip -d ./data/raw/
echo "Done"
