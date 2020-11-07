import Foundation
import ArgumentParser
import Bio

// command-line
struct biosw: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Collection of Swift Command-line Tool for Bioinformatics",
        subcommands: [gtf2bed.self, vcf2niehs.self])

    init() {}
}

// subcommands
struct gtf2bed: ParsableCommand {

    public static let configuration = CommandConfiguration(abstract: "Convert GTF to BED format")

    // optional argument
    // @Option(name: .shortAndLong, default: false, help: "Convert to 1-based coordinate")
    
    @Flag(name: .shortAndLong, help: "Convert to 1-based coordinate")
    private var base1: Bool
    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    // positional argument
    @Argument(help: "Input gtf file")
    private var gtf: String
    @Argument(help: "Output bed file")
    private var bed: String
    
    
    func run() throws {
        let bl = BSLogger.defaultLogger
        if verbose {
            bl.logger?.logLevel = .debug
        }
        bl.logger?.debug("Program start")
        let start = CFAbsoluteTimeGetCurrent()
        //let start = Date()
        let gtf_parser = GTF(gtf)
        let base0 = base1 ? false : true
        gtf_parser.toBed(filename: bed, coordinateBase0: base0)
        let end = CFAbsoluteTimeGetCurrent()
        let t:String = String(format:"%.3f", end - start)
        // let time = Date().timeIntervalSince(start) * 1_000)) // ms
        bl.logger?.debug("Program end. Time used: \(t) s")
    }
}


// subcommands
struct vcf2niehs: ParsableCommand {

    public static let configuration = CommandConfiguration(abstract: "Convert VCF to NIEHS compact format")

    // optional argument
    @Option(name: .customLong("het"), default: 20, help: "Heterozygote threshold, default: 20")
    private var het_thresh: Float
    
    @Option(name: .long, default: 50, help: "QUAL Field threshold , default: 50")
    private var qual: Float
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    // positional argument
    @Argument(help: "Input vcf file")
    private var vcf: String
    @Argument(help: "Output compact file")
    private var out: String
    
    func run() throws {
        let bl = BSLogger.defaultLogger
        if verbose {
            bl.logger?.logLevel = .debug
        }
        bl.logger?.debug("Program start")
        let start = CFAbsoluteTimeGetCurrent()
        //let start = Date()
        let vcf_parser = NIEHS(from: vcf)
        vcf_parser.toNIEHS(filename: out, qual: qual, heterozyote_thresh: het_thresh)
        let end = CFAbsoluteTimeGetCurrent()
        let t:String = String(format:"%.3f", end - start)
        // let time = Date().timeIntervalSince(start) * 1_000)) // ms
        bl.logger?.debug("Program end. Time used: \(t) s")
    }
}


// need to be set, then it works on command-line
biosw.main()
