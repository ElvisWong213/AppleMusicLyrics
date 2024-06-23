//
//  MusicLyrics.swift
//  
//
//  Created by Elvis on 16/06/2024.
//

import Foundation

// MARK: - MusicLyrics
public struct MusicLyrics: Codable, Hashable {
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
public struct Line: Codable {
    public var begin: TimeInterval
    public var end: TimeInterval
    public var text: String
}

extension Line: CustomStringConvertible, Hashable {
    public var description: String {
        return "Begin: \(begin), End: \(end), Text: \(text)"
    }
}
