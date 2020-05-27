//
//  utils.swift
//  
//
//  Created by Zhuoqing Fang on 5/27/20.
//
import Foundation

// read file line by line
class File {
    init? (_ path: String) {
        errno = 0
        file = fopen(path, "r")
        if file == nil {
            perror(nil)
            return nil
        }
    }
    
    deinit {
        fclose(file)
    }

    func testIndex(line: String) -> Bool {
        guard line.lastIndex(of: "\r") == nil else {
            return false
        }
        guard line.lastIndex(of: "\n") == nil else {
            return false
        }
        guard line.lastIndex(of: "\r\n") == nil else {
            return false
        }
        return true
    }

    func getLine() -> String? {
        var line = ""
        repeat {
            var buf = [CChar](repeating: 0, count: 1024)
            errno = 0
            if fgets(&buf, Int32(buf.count), file) == nil {
                if feof(file) != 0 {
                    return nil
                } else {
                    perror(nil)
                    return nil
                }
            }
            line += String(cString: buf)
//        } while (line.lastIndex(of: "\r") == nil)
        } while testIndex(line: line)
        return line
    }
    private var file: UnsafeMutablePointer<FILE>? = nil
}

