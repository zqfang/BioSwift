# Swift-Bio
## Introduction
A collection of toy `command-line` tools written in `Swift` for bioinformatic data wrangling.    
Each tool is a subcommand of `biosw`. 

## Usage:
1. Convert GTF to BED format
```shell
biosw gtf2bed gencode.gtf out.bed
```
2. More will be added if worth to.


## Installation
### Build
```shell
cd swift-bio
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


## Others
### 1. FileIO system in Swift quit different from C/C++, Python et.al
Swift is slow when reading large text files with the code like  
```swift
try? String(contentsOf: fileURL,
            encoding: .utf8)
    .split(separator: "\n") 
    .forEach { line in print(line)}
```
**NOTE**: Since `String` reads the whole file once, instead of line by line, it took a long time to read large size files. Reading file line by line is much more efficiently, but you have to write your own parser.

### 2. An experimental 2D Array with Numpy-like slicing
`Array2D` is only for testing purpose. An example of swift code:
```swift
import Bio
// init 2d array
var arr = Array2D<Int>(rows:10, columns:5, initialValue: 0 )
// assign value
arr[1,4] = 1 
arr[5,2] = 6

print(arr[5]) // [0, 0, 6, 0, 0]

print(arr[[1,3],nil]) // [[0, 0, 0, 0, 1], [0, 0, 0, 0, 0]]
print(arr[2,nil]) // [0, 0, 0, 0, 0]
print(arr[1..<6, 3..<5]) // [[0, 1], [0, 0], [0, 0], [0, 0], [0, 0]]


// init 2d array
let arr2 = Array2D<Int>(arr)
XCTAssertEqual(arr2[5,2], 6)
```


###  Generate a template Swift package called BioSwift
```
mkdir BioSwift && cd BioSwift
swift package init --type executable
swift package generate-xcodeproj # xcode 
```
