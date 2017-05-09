## Gather features from all stars and combine them in a data.frame
##

## Read what we were provided
d.clean <- read.table(file.path("..", "data", "raw", "Data_Batch1.txt"),
                      skip = 13, sep = ",")
names(d.clean) <- c("ID","magnitude","Cadence","duration","latitude","longitude",
                    "Teff","Teff_error","logg","logg_error","Type")
d.clean$ID <- substring(d.clean$ID, 5)

d.noisy <- read.table(file.path("..", "data", "raw", "Data_Batch1_noisy.txt"),
                      skip = 13, sep = ",")
names(d.noisy) <- c("ID","magnitude","Cadence","duration","latitude","longitude",
                    "Teff","Teff_error","logg","logg_error","Type")
d.noisy$ID <- substring(d.noisy$ID, 5)

## Peaks detected in the PDS

d.clean.pf <- list.files(file.path("..", "data", "modified"),
                         pattern = "-clean.peaks")

for(i in 1:length(d.clean.pf)) {
    f.id <- regmatches(d.clean.pf[i], regexpr("[[:digit:]]+", d.clean.pf[i]))
    f.l <- read.csv(file.path("..", "data", "modified",
                              paste("Star", f.id, "-clean.csv", sep = "")))
    f.p <- read.csv(file.path("..", "data", "modified",
                              paste("Star", f.id, "-clean.peaks", sep = "")))
    d.clean[d.clean$ID == f.id, "var_lc"] <- var(f.l$flux, na.rm = TRUE)
    d.clean[d.clean$ID == f.id, "num_peaks"] <- dim(f.p)[1]
    d.clean[d.clean$ID == f.id, "median_peaks"] <- median(f.p$frequency)
    d.clean[d.clean$ID == f.id, "mad_peaks"] <- mad(f.p$frequency)
}

write.csv(d.clean, file.path("..", "data", "final","clean.csv"), row.names = FALSE, quote = FALSE)


d.noisy.pf <- list.files(file.path("..", "data", "modified"),
                         pattern = "-noisy.peaks")

for(i in 1:length(d.noisy.pf)) {
    f.id <- regmatches(d.noisy.pf[i], regexpr("[[:digit:]]+", d.noisy.pf[i]))
    f.l <- read.csv(file.path("..", "data", "modified",
                              paste("Star", f.id, "-noisy.csv", sep = "")))
    f.p <- read.csv(file.path("..", "data", "modified",
                              paste("Star", f.id, "-noisy.peaks", sep = "")))
    d.noisy[d.noisy$ID == f.id, "var_lc"] <- var(f.l$flux, na.rm = TRUE)
    d.noisy[d.noisy$ID == f.id, "num_peaks"] <- dim(f.p)[1]
    d.noisy[d.noisy$ID == f.id, "median_peaks"] <- median(f.p$frequency)
    d.noisy[d.noisy$ID == f.id, "mad_peaks"] <- mad(f.p$frequency)
}

write.csv(d.noisy, file.path("..", "data", "final","noisy.csv"), row.names = FALSE, quote = FALSE)

