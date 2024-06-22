//
//  MusicLyrics.swift
//  
//
//  Created by Elvis on 16/06/2024.
//

import Foundation

// MARK: - MusicLyrics
public struct MusicLyrics: Decodable {
    public var lines: [Line]
}

extension MusicLyrics: CustomStringConvertible {
    public var description: String {
        var output = ""
        for line in self.lines {
            output += "\n\t\(line)"
        }
        return "Lyrics: \(output)"
    }
}

// MARK: - Line
public struct Line: Decodable {
    var begin: TimeInterval
    var end: TimeInterval
    var text: String
}

extension Line: CustomStringConvertible {
    public var description: String {
        return "Begin: \(begin), End: \(end), Text: \(text)"
    }
}
