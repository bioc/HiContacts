# HiContacts

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check-bioc](https://github.com/js2264/HiContacts/actions/workflows/check-bioc.yml/badge.svg)](https://github.com/js2264/HiContacts/actions/workflows/check-bioc.yml)
[![pkgdown](https://github.com/js2264/HiContacts/workflows/pkgdown/badge.svg)](https://github.com/js2264/HiContacts/actions)
<!-- badges: end -->

HiContacts provides tools to investigate `(m)cool` matrices imported in R by `HiCExperiment`. 

It leverages the `HiCExperiment` class of objects, built on pre-existing Bioconductor objects, namely `InteractionSet`, `GenomicInterations` and `ContactMatrix` (`Lun, Perry & Ing-Simmons, F1000Research 2016`), and provides **analytical** and **visualization** tools to investigate contact maps. 

## Installation

`HiContacts` is available in Bioconductor. To install the current release, use:

```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("HiContacts")
```

To install the most recent version of `HiContacts`, you can use:

```r
install.packages("devtools")
devtools::install_github("js2264/HiContacts")
library(HiContacts)
```

## Citation

If you are using `HiContacts` in your research, please cite: 

> Serizay J (2022). _HiContacts: HiContacts: R interface to cool files_.
> R package version 1.1.0
> <https://github.com/js2264/HiContacts>.

## How to use `HiContacts`

`HiContacts` includes a introduction vignette where its usage is 
illustrated. To access the vignette, please use:

```r
vignette('HiContacts')
```

## Overview

### Import a .(m)cool file as `HiCExperiment`

```r
mcool_file <- HiContactsData::HiContactsData('yeast_wt', format = 'mcool')
range <- 'I:20000-80000' # range of interest
lsCoolResolutions(mcool_file, verbose = TRUE)
hic <- HiCExperiment::import(mcool_file, format = 'mcool', focus = range, resolution = 1000)
hic
```

### Plotting matrices 

```r
plotMatrix(hic, use.scores = 'count')
plotMatrix(hic, use.scores = 'balanced', limits = c(-4, -1))
```

### Distance law, a.k.a. P(s)

```r
hic <- Contacts(
    mcool_file, 
    pairs = HiContactsData::HiContactsData('yeast_wt', format = 'pairs')
)
ps <- distanceLaw(hic)
plotPs(ps, aes(x = binned_distance, y = norm_p))
```

### Virtual 4C

```r
hic <- Contacts(mcool_file, res = 1000)
v4C <- virtual4C(hic, viewpoint = GRanges('V:150000-170000'))
gg4C(v4C, aes(x = center, y = score, col = chr)) + 
    facet_wrap(~chr, scales = 'free_x')
```

### Cis-trans ratios

```r
hic <- Contacts(mcool_file, res = 1000)
cisTransRatio(hic)
```

### Mapping topological features 

#### Compartments 

```r
mcool_file <- '/home/rsg/Projects/20221214_HiContacts_compartments-TADs-loops/HFFc6.mcool'
hic <- import(mcool_file, format = 'mcool', resolution = 100000)
genome <- Biostrings::readDNAStringSet('~/genomes/hg38/hg38.fa')

# - Get compartments
hic <- getCompartments(hic, genome, autocorrelation = TRUE, BPPARAM = BiocParallel::SerialParam(progressbar = TRUE))

# - Export compartments as bigwig and bed files
rtracklayer::export(IRanges::coverage(metadata(hic)$eigens, weight = 'eigen'), 'HFFc6_compartments.bw')
rtracklayer::export(
    topologicalFeatures(hic, 'compartments')[topologicalFeatures(hic, 'compartments')$compartment == 'A'], 
    'HFFc6_A-compartments.bed'
)
rtracklayer::export(
    topologicalFeatures(hic, 'compartments')[topologicalFeatures(hic, 'compartments')$compartment == 'B'], 
    'HFFc6_B-compartments.bed'
)

# - Generate saddle plot
p <- plotSaddle(hic)
```

#### Insulation and chromatin domains 

```r
mcool_file <- '/home/rsg/Projects/20221214_HiContacts_compartments-TADs-loops/HFFc6.mcool'
hic <- import(mcool_file, format = 'mcool', resolution = 100000)

# - Compute insulation score
hic <- getDiamondInsulation(
    hic,
    resolution = 10000, 
    window_size = 100000,
    BPPARAM = BiocParallel::SerialParam(progressbar = TRUE)
) |> getBorders()

# - Export insulation as bigwig track and borders as bed file
rtracklayer::export(IRanges::coverage(metadata(hic)$insulation, weight = 'insulation'), 'HFFc6_insulation.bw')
rtracklayer::export(topologicalFeatures(hic, 'borders'), 'HFFc6_borders.bed')
```

