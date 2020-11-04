//
//  File.swift
//  
//
//  Created by Zhuoqing Fang on 9/18/20.
//

import Foundation


/// represent each record 
class Variant {
    public var CHROM: String
    public var POS: String
    public var ID: String
    public var REF: String
    public var ALT: String
    public var QUAL: String
    public var FILTER: String
    public var INFO: [String: String?]
    public var FORMAT: [String: String]
    private var _variant: String
    
    lazy var variantType: String? = { //snp/indel/sv
        if let val = INFO["SVTYPE"] {
            return val ?? nil
        }
        return nil
    }()
//    public var isDeletion: Bool
//    public var isIndel: Bool
//    public var isSNP: Bool
//    public var isSV: Bool
//    public var numOfHet: Int?
//    public var numOfHomoRef: Int?
//    public var numOfHomoAlt: Int?
//    public var numOfUnknown: Int?
//    public var variantType: String //
    
    
    
    init(_ variant: String) {
        
//        if line1.starts(with: "#") {
//            return nil
//        }
        _variant = variant
        let line = variant.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // wrirte header
        let st = line.components(separatedBy: "\t")
    
        CHROM = st[0]
        POS = st[1]
        ID = st[2]
        REF = st[3]
        ALT = st[4]
        QUAL = st[5]
        FILTER = st[6]
    
        // info dict
        let infos = st[7].components(separatedBy: ";")
        INFO = [String: String?]()
        for item in infos {
            let k = item.components(separatedBy: "=")
            INFO.updateValue(k.count > 1 ? k[1]: nil, forKey: k[0])
        }
        // format dict
        let formats = st[8].components(separatedBy: ":")
        FORMAT = [String: String]()
        for s in st[9..<st.endIndex] {
            let ss = s.components(separatedBy: ":")
            for (fmt, val) in zip(formats, ss)
            {
                FORMAT.updateValue(val, forKey: fmt)
            }
        }
    }
}



//class VCF{
//    public var rawHeader: String
//    public var samples: [String] // list of samples
//    public var seqnames: [String] // list of chromosomes
//    private var _variant: [String]
//
//    public var variant: [Variant]
//    public func set_samples(samples: [String]) {} // samples to extract from
//
//
//
//    public init(filename: String)
//    {
//        let infile = URL(fileURLWithPath: filename)
//        if let s = StreamReader(url: infile, delimeter: "\n"){
//            while var line = s.nextLine() {
//                if line.starts(with: "#")
//                {
//                    rawHeader += line
//                    // regular expression
//                    let pattern = "contig=<ID=\\d>"
////                    let result = line.range(pattern, options: .regularExpression)
////                    text[results]! //
//                }
//                _variant.append(line)
//                //Variant(line)
//            }
//    }
//    }


    
//    public func write(toFile: String)
//    {
//        //let output: URL = URL(fileURLWithPath: filename)
//        //if !FileManager.default.isWritableFile(atPath: output.deletingLastPathComponent().path)
//        if !FileManager.default.isWritableFile(atPath: toFile)
//        {
//            assertionFailure("Could not write to \(toFile)")
//            exit(0)
//        }
//        var url = URL(fileURLWithPath: toFile)
//        do {
//            let outtext = self.outlines.joined(separator: "\n")
//            outtext.write(rawHeader)
//            try outtext.write(to: url, atomically: false, encoding: .utf8)
//        } catch{}
//        
//    }
    

