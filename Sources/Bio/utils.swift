//
//  utils.swift
//  
//
//  Created by Zhuoqing Fang on 5/27/20.
//
import Foundation
import Logging
import Darwin



// define a singleton
public class BSLogger {
    public var logger: Logger?
    public static let defaultLogger = BSLogger()
    private init (){
        if logger == nil {
        logger = Logger(label: "BioSwift.main",
                 factory: StreamLogHandler.standardError)
        }
    }
}

/// MARK: transpose a  2d array. same as python's list(zip(*arr))
extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

// Swifty FileReader, read file line by line
class StreamReader {
    let encoding: String.Encoding
    let chunkSize: Int
    let fileHandle: FileHandle
    var buffer: Data
    let delimPattern : Data
    var isAtEOF: Bool = false
    let fileURL: URL
    var fileOut: Array<String>?
    
    init?(url: URL, delimeter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096)
    {
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else { return nil }
        self.fileHandle = fileHandle
        self.chunkSize = chunkSize
        self.encoding = encoding
        self.fileURL = url
        buffer = Data(capacity: chunkSize)
        delimPattern = delimeter.data(using: .utf8)!
    }
    
    deinit {
        fileHandle.closeFile()
    }
    
    func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.removeAll(keepingCapacity: true)
        isAtEOF = false
    }
    
    func nextLine() -> String? {
        if isAtEOF { return nil }
        
        repeat {
            if let range = buffer.range(of: delimPattern, options: [], in: buffer.startIndex..<buffer.endIndex) {
                let subData = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
                let line = String(data: subData, encoding: encoding)
                buffer.replaceSubrange(buffer.startIndex..<range.upperBound, with: [])
                return line
            } else {
                let tempData = fileHandle.readData(ofLength: chunkSize)
                if tempData.count == 0 {
                    isAtEOF = true
                    return (buffer.count > 0) ? String(data: buffer, encoding: encoding) : nil
                }
                buffer.append(tempData)
            }
        } while true
    }
    /**
     * Read whole file one time from memory with pointers
     * WARNING: This method is too slow when file size is large. Don't use
     */
    func read() -> Array<String>? {
        let data = try! Data(contentsOf: self.fileURL)
        return data.withUnsafeBytes {
                // $0.load(as: Double.self)
                return $0.split(separator: UInt8(ascii: "\n"))
                .map{ String(decoding: UnsafeRawBufferPointer(rebasing: $0), as: UTF8.self) }
        }
    }
}


//// File path (change this).
//let path = "/Users/samallen/file.txt"
//
//do {
//    // Read an entire text file into an NSString.
//    let contents = try NSString(contentsOfFile: path,
//        encoding: String.Encoding.ascii.rawValue)
//
//    // Print all lines.
//    contents.enumerateLines({ (line, stop) -> () in
//        print("Line = \(line)")
//    })
//}


/// Read text file line by line in efficient way
public class LineReader {
   public let path: String

   fileprivate let file: UnsafeMutablePointer<FILE>!

   init?(path: String) {
      self.path = path
      file = fopen(path, "r")
      guard file != nil else { return nil }
   }

   public var nextLine: String? {
      var line:UnsafeMutablePointer<CChar>? = nil
      var linecap:Int = 0
      defer { free(line) }
      return getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
   }

   deinit {
      fclose(file)
   }
}

extension LineReader: Sequence {
   public func  makeIterator() -> AnyIterator<String> {
      return AnyIterator<String> {
         return self.nextLine
      }
   }
}


/**
 If you need to read a very large file you’ll want to stream it so you’re not loading the entire thing into memory at once.
 */
//class FileReader {
//
//    // MARK: - Private Members
//
//    private let file: URL
//    private let delimiter: Data
//    private let chunkSize: Int
//    private let encoding: String.Encoding
//    private let fileHandle: FileHandle
//    private var buffer: Data
//
//    // MARK: - Initializers
//
//    init(file: URL,
//         delimiter: String = "\n",
//         encoding: String.Encoding = .utf8,
//         chunkSize: Int = 4_096) throws {
//        self.file = file
//        self.delimiter = delimiter.data(using: .utf8)!
//        self.encoding  = encoding
//        self.chunkSize = chunkSize
//        self.buffer = Data()
//        self.fileHandle = try FileHandle(forReadingFrom: file)
//    }
//    func readLine() -> String? {
//        var nextLine: Data? = nil
//        var eof: Bool = false
//        while eof == false && nextLine == nil {
//            if let range = buffer.range(of: delimiter, options: []) {
//                nextLine = buffer.prefix(upTo: range.lowerBound)
//                buffer = buffer.suffix(from: range.upperBound)
//            } else {
//                let newData = fileHandle.readData(ofLength: chunkSize)
//                eof = newData.count == 0
//                buffer += newData
//            }
//        }
//        return nextLine.flatMap { String(data: $0, encoding: .utf8) }
//    }
//}
//
