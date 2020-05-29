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
    //deinit{} // no () here
    
    public func toBed() {
        if FileManager.default.fileExists(atPath: self.input.path)
        {
            BSLogger.debug("Found \(self.input.path)")
        }
        if let s = StreamReader(url: self.input){
        BSLogger.debug("Read gtf")
        while let line = s.nextLine() {
                self._parse(line)
            }
        }
        // read()
        write()
    }
    private func _getAttribute(_ line: String) -> [String:String]{
        var dict = [String:String]()
        let attr = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).split(separator: ";")
        //for (i,item) in attr.enumerate() {}
        for item in attr {
            let trimmed = item.trimmingCharacters(in: .whitespacesAndNewlines).split(separator:" ")
            dict.updateValue(String(trimmed[1]).replacingOccurrences(of: "\"", with: ""),
                             forKey: String(trimmed[0]))
        }
        return dict
    }
    private func _parse(_ line: String) {
        if line.starts(with: "#") {
            return
        }
        let arr = line.split(separator: "\t")
        if arr[2] == "gene" {
            let last = arr.last! // last element
            let attr = self._getAttribute(String(last))
            // makesure gene_id exists
            if let gid = attr["gene_id"] {
                var outline:String = "\(gid)\t\(attr["gene_name"]!)\t\(arr[6])"
                var chrStart = Int(arr[3])!
                let chrEnd = Int(arr[4])!
                chrStart -= 1
                outline = "\(arr[0])\t\(chrStart)\t\(chrEnd)\t" + outline
                _outlines.append(outline)

            } else {
                return
            }
        }
    }
    /**
     * Converts tuples to dict
     */
    public func tuple2dict<K,V>(_ tuples:[(K,V)])->[K:V]{
        var dict:[K:V] = [K:V]()
        tuples.forEach {dict[$0.0] = $0.1}
        return dict
    }
    /**
     * Read whole file one time.
     * WARNING: This method is too slow when file size is large. Don't use
     */
    public func read() {
        BSLogger.debug("Read gtf")
        try? String(contentsOf: self.input,
                    encoding: .utf8)
            .split(separator: "\n") // "\n"
            .forEach { line in self._parse(String(line))}
    }
    // write file
    public func write(){
        BSLogger.debug("Write bed")
        do {
            let outline = self._outlines.joined(separator: "\n")
            try outline.write(to: self.output, atomically: false, encoding: .utf8)
        } catch{}
    }
}

    
    

