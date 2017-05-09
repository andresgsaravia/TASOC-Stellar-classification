#!/bin/bash

for s in ../data/modified/*-clean.pds
do
    bs=`basename $s | cut -d'.' -f1`
    maybe_sub.sh -n -i 100000 Rscript pds-wavCWTPeaks.R -p "$s" -o "../data/modified/$bs.peaks"
    echo $bs
done

for s in ../data/modified/*-noisy.pds
do
    bs=`basename $s | cut -d'.' -f1`
    maybe_sub.sh -n -i 100000 Rscript pds-wavCWTPeaks.R -p "$s" -o "../data/modified/$bs.peaks"
    echo $bs
done

