## Author: Andrés G. Saravia

library(argparser, quietly=TRUE)

## Where are we located?
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)

## Get the file names and options
p <- arg_parser("Change the simulated light-curve to CSV with headers.")
p <- add_argument(p, arg = "--tseries", nargs=1, default = "raw.dat",
                  help = "File name of the time-series in tsv format with the first column giving the time and the second the flux.",
                  type = "character", flag = FALSE)
p <- add_argument(p, arg = "--output", nargs=1, default = "lc.csv",
                  help = "File name on which to save the filtered time-series",
                  type = "character", flag = FALSE)
argv <- parse_args(p)


## Check the provided tseries file is valid
if(!file.exists(argv$tseries))
    stop(paste("Could not find the time-series file:", argv$tseries))

## Read the lightcurve and make the filter
d.lc <- read.table(argv$tseries, na.strings = "nan")
names(d.lc) <- c("time", "flux", "quality")
d.lc <- d.lc[is.finite(d.lc$flux),]
d.lc <- d.lc[!is.na(d.lc$flux),]

## Save the results
write.csv(d.lc, file = argv$output, row.names = FALSE, quote = FALSE)
