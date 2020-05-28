# BioSwift
This is my first toy command line tool written in pure Swift .  

## Introduction
A collection of handy tool for daily bioinformatic data processing.  
Each handy tool is a subcommand of bioswift. 

## Usage:
1. Convert GTF to BED format
```shell
biosw gtf2bed gencode.gtf out.bed
```

## Dev
### Build
```shell
cd BioSwift
swift build
# build output in .build/debug

# test if build successfully
swift run biosw
```
### Build Release version
```shell
# build output in .build/release
swift build --configuration release
```


### Others
Generate a Swift package called BioSwift
```
mkdir BioSwift && cd BioSwift
swift package init --type executable
swift package generate-xcodeproj # xcode 
```
