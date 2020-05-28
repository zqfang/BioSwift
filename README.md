# Swift-Bio
## Introduction
A collection of handy `command-line` tools written in `Swift` for bioinformatic data wrangling.    
Each handy tool is a subcommand of `biosw`. 

## Usage:
1. Convert GTF to BED format
```shell
biosw gtf2bed gencode.gtf out.bed
```
2. More will implemented when I have time


## Installation
### Build
```shell
cd BioSwift
swift build
# build output in .build/debug

# test if build successfully
swift run biosw
```
###  Release 
```shell
# binary output in .build/release
swift build --configuration release
```

## Dev
### Use `Bio` as depency for your own package
To depend on the Bio API package, you need to declare your dependency in your Package.swift:
```
.package(url: "https://github.com/zqfang/swift-bio", from: "0.0.1"),
```
and to your `application/library` target, add `Bio` to your dependencies, e.g. like this:
```
.target(name: "YourApp", dependencies: ["Bio"]),
```


### Others
Generate a template Swift package called BioSwift
```
mkdir BioSwift && cd BioSwift
swift package init --type executable
swift package generate-xcodeproj # xcode 
```
