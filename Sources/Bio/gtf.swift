//
//  File.swift
//  
//
//  Created by Zhuoqing Fang on 5/27/20.
//

import Foundation

struct GTFRecord {
    
    public var CHROM: String
    public var SOURCE: String
    public var FEATURE: String
    public var START: Int64
    public var END: Int64
    public var SCORE: String
    public var STRAND: String
    public var FRAME: String
    public var ATTR: [String: String]
    
    // gtf path and bed path
    public init(_ record:String) {
        let arr = record.components(separatedBy: "\t")
        CHROM = String(arr[0])
        SOURCE = String(arr[1])
        FEATURE = String(arr[2])
        START = Int64(arr[3])!
        END = Int64(arr[4])!
        SCORE = String(arr[5])
        STRAND = String(arr[6])
        FRAME = String(arr[7])
        ATTR = [String:String]()
        _getAttribute(String(arr.last!))
        
    }
    //deinit{} // no () here
    private mutating func _getAttribute(_ line: String) {
                
        let temp = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ";")
        //for (i,item) in attr.enumerate() {}
        for item in temp {
            let trimmed = item.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            ATTR.updateValue(String(trimmed[1]).replacingOccurrences(of: "\"", with: ""),
                             
                             forKey: String(trimmed[0]))
        }
    }
}


public class GTF {
    let input: URL
    var base: Int64
    let bl = BSLogger.defaultLogger
    private var _records: [GTFRecord]
    
    // gtf path and bed path
    public init(_ gtf:String) {
        self.input = URL(fileURLWithPath: gtf)
        self._records = [GTFRecord]()
        base = 1
        
        if let s = StreamReader(url: self.input){
            bl.logger?.debug("Parse gtf")
            while let line = s.nextLine() {
                if line.starts(with: "#") {
                    continue
                }
                _records.append(GTFRecord(line))
                }
        }
    }
    //deinit{} // no () here
    
    public func toBed(filename: String, coordinateBase0: Bool = true) {
        if !coordinateBase0 {
            base = 0
        }
        let output: URL = URL(fileURLWithPath: filename)
        if !FileManager.default.isWritableFile(atPath: output.deletingLastPathComponent().path) {
            assertionFailure("Could not write to \(filename)")
            exit(0)
        }
        
        // write
        bl.logger?.debug("Write bed")
        let records = self._records.filter {record in return record.FEATURE == "gene" }
        var outlines = ""
        for rec in records {
            outlines.append("\(rec.CHROM)\t\(rec.START - base)\t\(rec.END)\t\(rec.ATTR["gene_name"] ?? "-")\t\(rec.SCORE)\t\(rec.STRAND)\n")
        }
        try? outlines.write(to: output, atomically: false, encoding: .utf8)
        
    }
    /**
     * Read whole file one time.
     * WARNING: This method is too slow when file size is large. Don't use
     */
//    public func read() {
//        bl.logger?.debug("Read gtf")
//        try? String(contentsOf: self.input,
//                    encoding: .utf8)
//            .split(separator: "\n") // "\n"
//            .forEach { line in self._parse(String(line))}
        
//        var lines = try! String(contentsOfFile: self.input.path)
//            .split{$0 == "\n"}
//            .map(String.init).map(self._parse)
//        self._outlines = lines

}
