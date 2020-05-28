import Foundation
//import Numerics
import ArgumentParser
import Logging


// create a logger
LoggingSystem.bootstrap(StreamLogHandler.standardError)
var logger = Logger(label: "BioSwift.main")

// command-line
struct BioSwift: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Collection of Swift Ccommand-line Tool for Bioinformatics",
        subcommands: [gtf2bed.self])

    init() {}
}
// subcommands
struct gtf2bed: ParsableCommand {

    public static let configuration = CommandConfiguration(abstract: "Convert GTF to BED format")

    // optional argument
    
    //@Option(name: .shortAndLong, default: nil, help: "")
    //private var week: Int?
    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    // positional argument
    @Argument(help: "Input gtf file")
    private var gtf: String
    @Argument(help: "Output bed file")
    private var bed: String
    
    func run() throws {
        
        if verbose {
            logger.logLevel = .debug
        }
        logger.debug("Program start")
        let gtf_parser = GTF(from: gtf, to: bed)
        gtf_parser.toBed()
        logger.debug("Program end")
    }
}

// need to be set, then it works on command-line
BioSwift.main()
