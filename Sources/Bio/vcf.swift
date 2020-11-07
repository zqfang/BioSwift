//
//  File.swift
//  
//
//  Created by Zhuoqing Fang on 9/18/20.
//

import Foundation


/// represent each record
public class Variant {
    public var CHROM: String
    public var POS: String
    public var ID: String
    public var REF: String
    public var ALT: String
    public var QUAL: String
    public var FILTER: String
    public var INFO: [String: String?]
    public var FORMAT: [String:[String]]
    
    private var _variant: String
    
    lazy var variantType: String? = { //snp/indel/sv
        if let val = INFO["SVTYPE"] {
            return val ?? nil
        }
        return nil
    }()

    init(_ variant: String) {
//        if line1.starts(with: "#") {
//            return nil
//        }
        _variant = variant.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // wrirte header
        let st = _variant.components(separatedBy: "\t")
    
        CHROM = st[0]
        POS = st[1]
        ID = st[2]
        REF = st[3]
        ALT = st[4]
        QUAL = st[5]
        FILTER = st[6]
        FORMAT = [String:[String]]()
        // info dict
        let infos = st[7].components(separatedBy: ";")
        INFO = [String: String?]()
        for item in infos {
            let k = item.components(separatedBy: "=")
            INFO.updateValue(k.count > 1 ? k[1]: nil, forKey: k[0])
        }
        // format dict
        let format = st[8].components(separatedBy: ":")
        var SAMPLES = [[String]]()
        for s in st[9..<st.endIndex] {
            SAMPLES.append(s.components(separatedBy: ":"))
        }
        SAMPLES = SAMPLES.transposed()
        
        for (fmt, s) in zip(format, SAMPLES) {
          FORMAT[fmt] = s
        }
    
    }
    
}


public class VCF {
    public var rawHeader: String
    public var variants: [Variant]
    public var SAMPLES: [String]=[]
    
    public init(filename: String)
    {
        
        variants = [Variant]()
        rawHeader = ""
        let infile = URL(fileURLWithPath: filename)
        if let s = StreamReader(url: infile, delimeter: "\n"){
            while let line = s.nextLine()
            {
                if line.starts(with: "#")
                {
                    rawHeader += line
                    // get sample names
                    if line.starts(with: "#CHROM")
                    {
                        let temp = line.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\t")
                        SAMPLES = Array(temp.suffix(from: 9))
                    }
                    continue
                }
                variants.append(Variant(line))
            }
        }
    }
    private func write(toFile: String)
    {
        if !FileManager.default.isWritableFile(atPath: toFile)
        {
            assertionFailure("Could not write to \(toFile)")
            exit(0)
        }
        let url = URL(fileURLWithPath: toFile)

        var outtext = ""
        outtext = rawHeader+outtext
        try? outtext.write(to: url, atomically: false, encoding: .utf8)

        
    }
    

}
