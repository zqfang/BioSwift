//
//  File.swift
//  
//
//  Created by Zhuoqing Fang on 5/27/20.
//

import Foundation

class GTF {
    let input: String
    let output: URL
    // gtf path and bed path
    init(from gtf:String, to bed: String) {
        self.input = gtf
        self.output = URL(fileURLWithPath: bed)
    }
    func run() {
        var _outlines = [String]() // initialize empty
        if let file = File(self.input){
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
                    var chrEnd = Int(arr[4])!
                    if arr[6] == "+"{
                        chrStart -= 1
                    }
                    else if arr[6] == "-" {
                        chrEnd += 1
                    } else {}
                    outline = "\(arr[0])\t\(chrStart)\t\(chrEnd)\t" + outline
                    _outlines.append(outline)
                    //print(outline)
                  }
          }
        }
        write(_outlines)
    }
    
    func getAttribute(_ line: String) -> [String:String]{
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
    func dict<K,V>(_ tuples:[(K,V)])->[K:V]{
        var dict:[K:V] = [K:V]()
        tuples.forEach {dict[$0.0] = $0.1}
        return dict
    }
    // read whole file
    func read(_ url: URL) -> [String]{
        var _outlines = [String]() // initialize empty
        try? String(contentsOf: url, encoding: .utf8)
            .split(separator: "\n")
            .forEach { line in
                _outlines.append(String(line))}
        
        return _outlines
    }
    func write(_ lines:[String]){
        do {
            let outline = lines.joined(separator: "\n")
            try outline.write(to: self.output, atomically: false, encoding: .utf8)
        } catch{}
    }
}

    
    

