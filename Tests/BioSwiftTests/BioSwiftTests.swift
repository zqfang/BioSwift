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
        for i in 0..<5 {
            print(arr[1,i])
        }
        print()
        XCTAssertEqual(arr[1,4], 1)
        XCTAssertEqual(arr[5,2], 6)
     
    }
    
    static var allTests = [
        ("Array2DTest", testArr2D),
    ]
    
}


// init
// var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
// slicing
// let myCookie = cookies[column, row]
// set value
// cookies[column, row] = newCookie
