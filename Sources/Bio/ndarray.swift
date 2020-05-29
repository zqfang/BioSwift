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
    for _ in 0..<rows {
        let arow = Array(repeating: initialValue, count: columns)
        array.append(arow)
    }
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
