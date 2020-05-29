import XCTest
import class Foundation.Bundle
import Bio


final class BioSwiftTests: XCTestCase {
    func testArr2D() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        var arr = Array2D<Int>(rows:10, columns:5, initialValue: 0 )
        arr[1,4] = 1
        arr[5,2] = 6
        print("Print row 5:")
        print(arr[5])
        print(arr[[1,3],nil])
        print(arr[2,nil])
        print(arr[1..<6, 3..<5])
        XCTAssertEqual(arr[1,4], 1)
        XCTAssertEqual(arr[5,2], 6)
        
        let arr2 = Array2D<Int>(arr)
        XCTAssertEqual(arr2[5,2], 6)
    }
    func testGTF() throws {
        let testDataPath = PACKAGE_ROOT.path + "/data"
        let gtf = GTF(from: testDataPath+"/test.gtf",
                      to: testDataPath+"/test.bed")
        gtf.toBed()
    }
    func testBioSwift() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }
        let aaa = FileManager.default.currentDirectoryPath // -> /private/tmp
        //let aaa = FileManager.default.homeDirectoryForCurrentUser
        print("FileManger default directory: ", aaa)
        
        // test binary
        let bsBinary = productsDirectory.appendingPathComponent("biosw")
        let process = Process()
        process.executableURL = bsBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        XCTAssertNotNil(output)
    }
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
    fileprivate var PACKAGE_ROOT: URL {
        return URL(fileURLWithPath: #file.replacingOccurrences(of: "Tests/BioSwiftTests/BioSwiftTests.swift", with: ""))
    }
        
    static var allTests = [
        ("Array2DTest", testArr2D),
        ("FileIOTest", testGTF),
        ("BioSwift",  testBioSwift),
    ]
    
}
