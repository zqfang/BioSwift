//
//  bed.swift
//  
//
//  Created by Zhuoqing Fang on 11/8/20.
//

import Foundation

struct BED {
    public var chrom: String
    public var start: Int
    public var end: Int
    public var name: String
    public var score: String
    public var strand: String
//    // for ucsc track plot
//    public var thickStart: Int
//    public var thickEnd: Int
//    public var itemRGB
//    // blocks (exons) number
//    public var blockCount: Int
//    // blocks sizes
//    public var blockSizes: Int
//    public var blockStarts: Int
    init () {
        chrom = ""
        start = 0
        end = 0
        name = ""
        score = ""
        strand = ""
    }
    // BED3
    init(chrom: String, start: Int, end: Int) {
        self.chrom = chrom
        self.start = start
        self.end = end
        name = ""
        score = ""
        strand = ""
    }
    // BED4
    init(chrom: String, start: Int, end: Int, strand: String){
        self.chrom = chrom
        self.start = start
        self.end = end
        name = ""
        score = ""
        self.strand = strand
    }
    // BED6
    init(chrom: String, start: Int, end: Int, name:String, score: String, strand: String){
        self.chrom = chrom
        self.start = start
        self.end = end
        self.name = name
        self.score = score
        self.strand = strand
    }
}


// bed protocol
protocol BEDable {
    var chrom: String {get set}
    var start: Int {get set}
    var end: Int {get set}
    
    func overlap() -> BED
    func subtract() -> BED
}

extension BEDable {
    public func overlap(with bed:BED) -> BED{
        if self.chrom != bed.chrom {
            return BED()
        }
        return BED(chrom: self.chrom, start: max(self.start, bed.start), end: min(self.end, bed.end))
    }
}





