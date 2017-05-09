#!/bin/bash

for s in ../data/modified/*-clean.csv
do
    bs=`basename $s | cut -d'.' -f1`
    maybe_sub.sh -n -i 100000 Rscript pds.R -t "$s" -o "../data/modified/$bs.pds"
    echo $bs
done

for s in ../data/modified/*-noisy.csv
do
    bs=`basename $s | cut -d'.' -f1`
    maybe_sub.sh -n -i 100000 Rscript pds.R -t "$s" -o "../data/modified/$bs.pds"
    echo $bs
done

