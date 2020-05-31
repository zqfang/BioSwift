//
//  ndarray.swift
//  
//
//  Created by Zhuoqing Fang on 5/28/20.
//

import Foundation

//public typealias Array2D = Array<Array<T>>
public struct Array2D<T> {
  public let columns: Int
  public let rows: Int
  fileprivate var array: [[T]]
    
  public init(rows: Int, columns: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = [[T]]()
//    // much faster version
//    let N = 300_000
//    var buffer = [Int64](repeating: 0, count: N)
    
//    buffer.withUnsafeMutableBufferPointer { buffer in
//        for i in 0 ..< N {
//            buffer[i] = test
//        }
//    }
    for _ in 0..<rows {
        let arow = Array(repeating: initialValue, count: columns)
        array.append(arow)
    }
  }
  public init(_ arr2d: [[T]]) {
    self.columns = arr2d[0].count
    self.rows = arr2d.count
    self.array = arr2d
  }
  public init(_ arr2d: Array2D<T>) {
    self.columns = arr2d.columns
    self.rows = arr2d.rows
    self.array = arr2d.array
  }
  public subscript(row: Int, column: Int) -> T {
    get {
      precondition(column < columns && column >= 0, "Column \(column) Index is out of range.")
      precondition(row < rows && row >= 0, "Row \(row) Index is out of range.")
      return array[row][column]
    }
    set {
      precondition(column < columns && column >= 0, "Column \(column) Index is out of range.")
      precondition(row < rows && row >= 0, "Row \(row) Index is out of range.")
      array[row][column] = newValue
    }
  }
    public subscript(row: Int) -> [T] {
        get {
         precondition(row >= 0 && row < rows, "Row \(row) Index is out of range.")
        return array[row]
        }
        set (vector) {
            precondition(vector.count == columns, "Column Number does not match")
            array[row] = vector
        }
    }
}

// fancy slicing
extension Array2D {
    public subscript(row: Int, column: [Int]) -> [T]{
        get {
            precondition(row >= 0 && row < rows, "Row ndex is out of range.")

            assert(column.min()! >= 0 && column.max()! < rows, "Column Index out of range.")
            var arr = Array<T>()
            column.forEach{ cc in arr.append(array[row][cc])}
            return arr
        }
        set (vector) {
            precondition(row >= 0 && row < rows, "Row ndex is out of range.")
            assert(column.min()! >= 0 && column.max()! < rows, "Column Index out of range.")
            assert(vector.count == column.count, "Element length not match")
            for (c,v) in zip(column, vector) {
                array[row][c] = v
            }
        }
    }
    public subscript(row: [Int], column: Int) -> Array2D<T>{
        get {
            precondition(column >= 0 && column < columns, "Column index is out of range.")
            assert(row.min()! >= 0 && row.max()! < rows, "Row index out of range.")
            var arr = [[T]]()
            row.forEach{ rr in arr.append([array[rr][column]])}
            
            return Array2D<T>(arr)
        }
        set (matrix) { // return [[T]], so matrix type is [[T]]

            precondition(column < columns && column >= 0, "Column \(column) Index is out of range.")
            assert(row.min()! >= 0 && row.max()! < rows, "Row index out of range.")
             assert(matrix.rows == row.count, "Element length not match")
            for (r,v) in zip(row, matrix.array) {
                array[r][column] = v[0] // v-> 2d array with one column
            }
        }
    }
    
    public subscript(row: [Int]?, column: [Int]?) -> Array2D<T>{
        get {
            var arr = [[T]]()
            if let r = row, let c = column {
                assert(r.min()! >= 0 && r.max()! < rows, "Row Index out of range." )
                assert(c.min()! >= 0 && c.max()! < columns, "Column Index out of range.")
                for (i, r0) in r.enumerated() {
                    var temp = Array<T>()
                    for (_, c0) in c.enumerated()  {
                        temp.append(array[r0][c0])
                    }
                    arr.insert(temp, at: i)
                }
            } else {
                if row == nil && column == nil
                {
                   return self
                }
                //var r0: Range<Int> = 0 ..< rows, c0: Range<Int> =  0 ..< columns
                var r0: [Int], c0: [Int]
                if let r = row {
                    assert(r.min()! >= 0 && r.max()! < rows, "Row Index out of range." )
                    r0 = r
                } else {
                     r0 = Array<Int>(0 ..< rows)
                }

                if let c = column {
                    assert(c.min()! >= 0 && c.max()! < columns, "Column Index out of range.")
                    c0 = c
                } else {
                     c0 = Array<Int>(0 ..< columns)
                }
                
                for (i, rr) in r0.enumerated() {
                    var temp = Array<T>()
                    for (_, cc) in c0.enumerated() {
                        temp.append(array[rr][cc])
                    }
                    arr.insert(temp, at: i)
                }
                }
             return Array2D<T>(arr)
        }
    set (matrix) {
        if let r = row, let c = column {
            assert(r.min()! >= 0 && r.max()! < rows, "Row Index out of range." )
            assert(c.min()! >= 0 && c.max()! < columns, "Column Index out of range.")
            assert(matrix.rows == r.count && matrix.columns == c.count, "Index out of range")
            for (i, r0) in r.enumerated() {
                for (j, c0) in c.enumerated()  {
                    array[r0][c0] = matrix[i,j]
                }
            }
        }else{
            assertionFailure("Could not assign value")
        }
        }
    }
}
//fancy slicing
extension Array2D {
    public subscript(row: Range<Int>?, column: Int) -> Array2D<T>{
        get {
            precondition(column >= 0 && column < columns, "Column index is out of range.")
            var arr = [[T]]()
            if let r = row, r.lowerBound >= 0 && r.upperBound <= rows
            {
                r.forEach{ rr in arr.append([array[rr][column]])}
            } else {
                let r0 = 0..<rows
                r0.forEach{ rr in arr.append([array[rr][column]])}
            }
            return Array2D<T>(arr)
            
        }
    }
    public subscript(row: Int, column: Range<Int>?) -> [T]{
        get {
            precondition(row >= 0 && row < rows, "Row index is out of range.")
            if let c = column {
                assert(c.lowerBound >= 0 && c.upperBound <= columns, "Column index out of range.")
                return Array<T>(array[row][c])
            } else {
                return array[row]
            }
        }
    }
    public subscript(row: Range<Int>?, column: Range<Int>?) -> Array2D{
        get {
            var arr = [[T]]()
            if let r = row, let c = column {
                assert(r.lowerBound >= 0 && r.upperBound <= rows, "Row index out of range." )
                assert(c.lowerBound >= 0 && c.upperBound <= columns, "Column index out of range.")
                r.forEach{rr in arr.append(Array<T>(array[rr][c]))}
            } else {
                if row == nil && column == nil
                {
                   return self
                }
                //var r0: Range<Int> = 0 ..< rows, c0: Range<Int> =  0 ..< columns
                var r0: Range<Int>, c0: Range<Int>
                if let r = row {
                    assert(r.lowerBound >= 0 && r.upperBound <= rows, "Row index out of range." )
                    r0 = r
                } else {
                     r0 = 0 ..< rows
                }

                if let c = column {
                    assert(c.lowerBound >= 0 && c.upperBound <= columns, "Column index out of range." )
                    c0 = c
                } else {
                     c0 = 0 ..< columns
                }
                r0.forEach{rr in arr.append(Array<T>(array[rr][c0]))}
            }
             return Array2D<T>(arr)
        }
    }
}

// pretty printable 2D array
extension Array2D: CustomStringConvertible {
    public var description: String {
        var str = Array<String>()
        for r in 0 ..< rows {
            str.append(" \(array[r]),")
        }
        let stro = str.joined(separator: "\n").dropLast().dropFirst()
        return "[\(stro)]"
    }
}
