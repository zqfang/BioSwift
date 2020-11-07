//
//  niehs.swift
//  
//
//  Created by Zhuoqing Fang on 6/15/20.
//

import Foundation

public class NIEHS {
    let bl = BSLogger.defaultLogger
    let input: URL
    public var strains: [String]
    public var qual: Float = 50
    public var heterozyote_thresh: Float = 20
    private var outlines: [String]
    public var variants: [Variant]
    /**
     - Parameters:
       - vcf: input file path
     */
    public init(from vcf:String) {
        self.input = URL(fileURLWithPath: vcf)
        self.outlines = [String]()
        self.strains = [String]()
        self.variants = [Variant]()
    }
    // MARK: parse vcf files
    //func _parse(line: String);
    
    /**
     Convert to NIEHS format
     */
    public func toNIEHS(filename: String, qual: Float = 50, heterozyote_thresh: Float = 20) {
        let output: URL = URL(fileURLWithPath: filename)
        if !FileManager.default.isWritableFile(atPath: output.deletingLastPathComponent().path) {
            assertionFailure("Could not write to \(filename)")
            exit(0)
        }
        self.qual = qual
        self.heterozyote_thresh = heterozyote_thresh
        bl.logger?.debug("Only keep SNPs with QUAL > \(qual) and Heterozyote_threshhold: \(heterozyote_thresh)")
        if let s = StreamReader(url: self.input){
        //let s = StreamingFileReader(path: self.input.path)
            bl.logger?.debug("Read VCF")
            while var line0 = s.nextLine() {
                self._parse(line: &line0)
            }
        }
        write(to: output)
    }
    
    public func write(to url: URL){
        bl.logger?.debug("Write compact")
        do {
            let outtext = self.outlines.joined(separator: "")
            try outtext.write(to: url, atomically: false, encoding: .utf8)
        } catch{}
    }
    
    
    
}

extension NIEHS {
    func _parse(line: inout String)
    {
        //line = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if line.starts(with: "##") {
            return
        }
        // wrirte header
        if line.starts(with: "#CHROM") {
            // good use of components separtedBy
            var st0 = "C57BL/6J" + line.components(separatedBy: "FORMAT")[1] + "\n"
            st0 = st0.replacingOccurrences(of: "B_C", with: "BALB")
            self.outlines.append(st0)
            let st = line.components(separatedBy: "\t")
            strains = Array(st[9..<st.endIndex])
//            for s in st[9..<st.endIndex] {
//                strains.append(s)
//            }
            return
        }
        let variant = Variant(line)
        
        //let newline = line.components(separatedBy: "\t")
        //assert(newline.count >= 9, "Eorr! check VCF input format")
        
        // skip indels
        if variant.REF.count > 1 || variant.INFO["INDEL"] == nil {
            return
        }
        
        if (variant.QUAL as NSString).floatValue < self.qual {
            return
        }
        
        //let tags = newline[8].components(separatedBy: ":")
        //var GTind:Int = -1, PLind: Int = -1

        guard let _ = variant.FORMAT["GT"], let _ = variant.FORMAT["PL"] else {
            assertionFailure("Could could not find GT or PL")
            return
        }

        let chrom = variant.CHROM
        let pos = variant.POS
        let alts = variant.ALT.components(separatedBy: ",")
        var hasAlt = Array(repeating: 0, count: alts.count)
        var alleles = Array(repeating: "NN", count: strains.count)
        
        for (s, _) in strains.enumerated() {
            //let strainFormats = newline[9+s].components(separatedBy: ":")
            // if "" -> NN
            let gtype = variant.FORMAT["GT"]![s] // gtype is a array
            if gtype == "./." || gtype == ".|." {
                //alleles[s] = "NN"
                continue
            }
            let GTss = gtype.replacingOccurrences(of: "|", with: "/").components(separatedBy: "/")
            
            if GTss.count != 2 {
                assertionFailure("Error format: \(gtype)")
            }
            
            if GTss[0] == "." || GTss[0] != GTss[1] {
                //alleles[s] = "NN"
                continue
            }
            var GTs = Array<Int>()
            // Now good calls
            for g in GTss {
                GTs.append((g as NSString).integerValue)
            }
            let index = (GTs[0] + 1) * (GTs[0] + 2) / 2 - 1
            let PLss = variant.FORMAT["PL"]![s].components(separatedBy: ",")
            if PLss.count != ((alts.count + 1) * (alts.count + 2) / 2) {
                bl.logger?.debug("PL Not Found")
                assertionFailure("Error format: \(variant.FORMAT["PL"]![s])")
            }
            
            var minScore: Float = 10000000000
            var PLs = Array<Float>()
            for g in PLss {
                PLs.append((g as NSString).floatValue)
            }
            
            for (i, _) in PLs.enumerated(){
                if i == index {
                    continue
                }
                if (PLs[i] - PLs[index]) < minScore {
                    minScore = PLs[i] - PLs[index]
                }
            }
            
            if minScore >= self.heterozyote_thresh {
                if GTs[0] > 0 {
                    alleles[s] = "\(alts[GTs[0] - 1])\(alts[GTs[0] - 1])"
                    hasAlt[GTs[0] - 1] = 1
                } else {
                    alleles[s] = "\(variant.REF)\(variant.REF)"
                }
            } //else {alleles[s] = "NN"}
            
        }

        // find good alt, only keep one good alt
        let numGoodAlt = hasAlt.reduce(0, +)
        if (numGoodAlt == 1) {
            //let theGoodAlt = hasAlt.firstIndex(of: 1)
            //var alt = alts[theGoodAlt]
            var alleles_pattern = String(variant.REF)
            for s in alleles {
                if s.first == "N" {
                    alleles_pattern.append("?")
                } else {
                    alleles_pattern.append(s.first!)
                }
            }
            
            //let alleles_compact = alleles_pattern.joined(separator: "")
            var out = "SNP_\(chrom)_\(pos)"
            out = out + "\t\(chrom)\t\(pos)\t\(alleles_pattern)\n"
            self.outlines.append(out)
        }

    }
}
