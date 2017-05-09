## Calculating a Lomb-Scargle periodogram.
## The input is assumed to have time-stamps with units of days
## The periodogram is given in units of micro-Hertz

library(argparser, quietly=TRUE)
library(lomb, quietly=TRUE)

## Where are we located?
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)

## Get the file names and options
p <- arg_parser("Make Lomb-Scargle periodogram. We assume the input time is given in days and give the periodogram frequencies in micro-Hertz.")
p <- add_argument(p, arg = "--tseries", nargs=1, default = "filtered.csv",
                  help = "File name of the time-series in csv format with two columns: `time` and `flux`.",
                  type = "character", flag = FALSE)
p <- add_argument(p, arg = "--output", nargs=1, default = "pds.csv",
                  help = "File name on which to save the calculated periodogram.",
                  type = "character", flag = FALSE)
argv <- parse_args(p)

## Check the provided tseries file is valid
if(!file.exists(argv$tseries))
    stop(paste("Could not find the time-series file:", argv$tseries))

## Calculating the periodogram
d.lc <- read.csv(argv$tseries, header = TRUE)
d.lsp <- lsp(x = d.lc$flux, times = d.lc$time, plot = FALSE)
d.lsp$scanned <- d.lsp$scanned * 10^6 / 86400    # Convert to uHz

## Normalization using the spectral window function
## http://dx.doi.org/10.1051/0004-6361/201424313
time_steps     <- round(d.lc$time / median(diff(d.lc$time)))
time_steps.idx <- time_steps - min(time_steps) + 1
ts_window <- data.frame(cbind(1:max(time_steps.idx) * median(diff(d.lc$time)) + d.lc$time[1],
                              vector(mode = "numeric", length = max(time_steps.idx))))
names(ts_window) <- c("time", "flux")
ts_window[time_steps.idx, "flux"] <- 1
ts_window.Mod2FFT <- Mod(fft(ts_window$flux))^2
a <- 2 * max(time_steps.idx) * var(d.lc$flux) / sum(ts_window.Mod2FFT * d.lsp$scanned[1])
d.pds <- data.frame(d.lsp$scanned, a * d.lsp$power)
names(d.pds) <- c("frequency","power")

## Save the results

write.csv(d.pds, file = argv$output,
          row.names = FALSE, quote = FALSE)
