//
//  MusicLyrics.swift
//  
//
//  Created by Elvis on 16/06/2024.
//

import Foundation

// MARK: - MusicLyrics
struct MusicLyrics: Decodable {
    var lines: [Line]
}

extension MusicLyrics: CustomStringConvertible {
    var description: String {
        var output = ""
        for line in self.lines {
            output += "\n\t\(line)"
        }
        return "Lyrics: \(output)"
    }
}

// MARK: - Line
struct Line: Decodable {
    var begin: TimeInterval
    var end: TimeInterval
    var text: String
}

extension Line: CustomStringConvertible {
    var description: String {
        return "Begin: \(begin), End: \(end), Text: \(text)"
    }
}
