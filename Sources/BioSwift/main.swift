import Foundation
//import Numerics
import ArgumentParser
import Logging


// create a logger
LoggingSystem.bootstrap(StreamLogHandler.standardError)
let logger = Logger(label: "BioSwift.BestExampleApp.main")

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
        logger.debug("Program start")
        if verbose {
            
            print("this is a test")

        }
        let parser = GTF(from: gtf, to: bed)
        parser.run()
        logger.debug("Program end")
    }
}


BioSwift.main()
