#!/bin/bash

for s in ../data/raw/*.clean
do
    bs=`basename $s | cut -d'.' -f1`
    maybe_sub.sh -n -i 50000 Rscript format_lightcurve.R -t "$s" -o "../data/modified/$bs-clean.csv"
    echo $bs
done

for s in ../data/raw/*.noisy_shuf
do
    bs=`basename $s | cut -d'.' -f1`
    maybe_sub.sh -n -i 50000 Rscript format_lightcurve.R -t "$s" -o "../data/modified/$bs-noisy.csv"
    echo $bs
done
