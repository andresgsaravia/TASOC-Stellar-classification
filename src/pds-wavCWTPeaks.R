## Find most significant peaks in pds

library(argparser, quietly=TRUE)
library(wmtsa, quietly=TRUE)

## Where are we located?
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)

## Get the file names and options
p <- arg_parser("Find most significant peaks in the pds.")
p <- add_argument(p, arg = "--pds", nargs=1, default = "pds.csv",
                  help = "File name of the pds in csv format with two columns: `frequency` and `power`.",
                  type = "character", flag = FALSE)
p <- add_argument(p, arg = "--output", nargs=1, default = "peaks.csv",
                  help = "File name on which to save the peaks found.",
                  type = "character", flag = FALSE)
argv <- parse_args(p)

## Check the provided tseries file is valid
if(!file.exists(argv$pds))
    stop(paste("Could not find the time-series file:", argv$tseries))

d.pds <- read.csv(argv$pds)
d.SS <- splus2R::signalSeries(data = d.pds$power, positions. = d.pds$frequency)
d.CWT <- wavCWT(x = d.SS)
d.CWTTree <- wavCWTTree(d.CWT)
d.peaks <- wavCWTPeaks(d.CWTTree, snr.min = 3, length.min = 7)
d.peaks <- data.frame(frequency = d.peaks$x, power = d.peaks$y)


write.csv(d.peaks, file = argv$output,
          row.names = FALSE, quote = FALSE)

