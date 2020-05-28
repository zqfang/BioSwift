//
//  File.swift
//  
//
//  Created by Zhuoqing Fang on 5/27/20.
//

import Foundation

public class GTF {
    let input: URL
    let output: URL
    var _outlines: Array<String>
    // gtf path and bed path
    public init(from gtf:String, to bed: String) {
        self.input = URL(fileURLWithPath: gtf)
        self.output = URL(fileURLWithPath: bed)
        self._outlines = [String]()
    }
    
    public func toBed() {
        //var _outlines = [String]() // initialize empty
        BSLogger.debug("Read gtf line by line")
        if let file = File(self.input.path){
            while let line = file.getLine() {
                if line.starts(with: "#") {
                    continue
                }
                let arr = line.split(separator: "\t")
                if arr[2] == "gene" {
                    let last = arr.last! // last element
                    let attr = self.getAttribute(String(last))
                    var outline:String = "\(attr["gene_id"]!)\t\(attr["gene_name"]!)\t\(arr[6])"
                    var chrStart = Int(arr[3])!
                    let chrEnd = Int(arr[4])!
                    chrStart -= 1
                    outline = "\(arr[0])\t\(chrStart)\t\(chrEnd)\t" + outline
                    _outlines.append(outline)
                    //print(outline)
                  }
          }
        }
        write()
    }
    
    private func getAttribute(_ line: String) -> [String:String]{
        var dict =  [String:String]()
        let attr = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).split(separator: ";")
        for item in attr {
            let trimmed = item.trimmingCharacters(in: .whitespacesAndNewlines).split(separator:" ")
            dict.updateValue(String(trimmed[1]).replacingOccurrences(of: "\"", with: ""),
                             forKey: String(trimmed[0]))
        }
        return dict
    }
    /**
     * Converts tuples to dict
     */
    public func tuple2dict<K,V>(_ tuples:[(K,V)])->[K:V]{
        var dict:[K:V] = [K:V]()
        tuples.forEach {dict[$0.0] = $0.1}
        return dict
    }
    // read whole file
    public func read() {
        BSLogger.debug("Read gtf one time")
        try? String(contentsOf: self.input,
                    encoding: .utf8)
            .split(separator: "\n")
            .forEach { line in
                self._outlines.append(String(line))}
    }
    // whole whole array
    public func write(){
        BSLogger.debug("Write bed")
        do {
            let outline = self._outlines.joined(separator: "\n")
            try outline.write(to: self.output, atomically: false, encoding: .utf8)
        } catch{}
    }
}

    
    

