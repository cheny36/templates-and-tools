#!/usr/bin/env Rscript

library("argparse")

parser <- ArgumentParser(description="")
parser$add_argument("file", help="input data tsv file")
parser$add_argument("-o", "--output", help="output prefix")
args <- parser$parse_args()

if(!is.null(args$output)) { out <- args$out } else {
    out <- sub("\\..*", "", args$file)
}

data <- read.table(args$file, header=T, sep="\t")



library("ggplot2")

pdf(file=paste0(out, ".pdf"))
p1 <-

dev.off()
