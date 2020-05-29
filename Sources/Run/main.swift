import Foundation
import ArgumentParser
import Bio

// command-line
struct biosw: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Collection of Swift Command-line Tool for Bioinformatics",
        subcommands: [gtf2bed.self])

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
        
        if verbose {
            Bio.BSLogger.logLevel = .debug
        }
        Bio.BSLogger.debug("Program start")
        let gtf_parser = GTF(gtf)
        let base0 = base1 ? false : true
        gtf_parser.toBed(filename: bed, coordinateBase0: base0)
        Bio.BSLogger.debug("Program end")
    }
}

// need to be set, then it works on command-line
biosw.main()
