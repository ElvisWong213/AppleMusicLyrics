//
//  SynedMusicLyrics.swift
//
//
//  Created by Elvis on 12/06/2024.
//

import Foundation

// MARK: - MusicLyrics
public struct SynedMusicLyrics: Codable, Equatable, Hashable {
    public var lines: [SynedLine]
}

extension SynedMusicLyrics: CustomStringConvertible {
    public var description: String {
        var output = ""
        for line in self.lines {
            output += "\n\t\(line)"
        }
        return "Lyrics: \(output)"
    }
}

// MARK: - Line
public struct SynedLine: Codable, Equatable {
    public var begin: TimeInterval
    public var end: TimeInterval
    public var words: [SynedWord]
    public var backgroundWords: [SynedWord]
    
    enum CodingKeys: String, CodingKey {
        case begin
        case end
        case words
        case backgroundWords = "background"
    }
    
    public init(begin: TimeInterval, end: TimeInterval, words: [SynedWord], backgroundWords: [SynedWord]) {
        self.begin = begin
        self.end = end
        self.words = words
        self.backgroundWords = backgroundWords
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.words = try container.decode([SynedWord].self, forKey: .words)
        self.backgroundWords = try container.decode([SynedWord].self, forKey: .backgroundWords)
        
        let beginString = try? container.decode(String.self, forKey: .begin)
        let beginTime = Converter.convertStringToTime(beginString)
        self.begin = beginTime
        
        let endString = try? container.decode(String.self, forKey: .end)
        let endTime = Converter.convertStringToTime(endString)
        self.end = endTime
    }
}

extension SynedLine: CustomStringConvertible, Hashable {
    public var description: String {
        var outputWords = ""
        var outputBackgroundWords = ""
        for word in self.words {
            outputWords += "\n\t\t\(word)"
        }
        for word in self.backgroundWords {
            outputBackgroundWords += "\n\t\t\(word)"
        }
        return "Begin: \(begin), End: \(end),\n\tWords: \(outputWords), \n\tBackground Words: \(outputBackgroundWords)"
    }
}

// MARK: - Word
public struct SynedWord: Codable, Equatable {
    public var begin: TimeInterval
    public var end: TimeInterval
    public var text: String
    
    public init(begin: TimeInterval, end: TimeInterval, text: String) {
        self.begin = begin
        self.end = end
        self.text = text
    }
    
    enum CodingKeys: CodingKey {
        case begin
        case end
        case text
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        
        let beginString = try? container.decode(String.self, forKey: .begin)
        let beginTime = Converter.convertStringToTime(beginString)
        self.begin = beginTime
        
        let endString = try? container.decode(String.self, forKey: .end)
        let endTime = Converter.convertStringToTime(endString)
        self.end = endTime
    }
}

extension SynedWord: CustomStringConvertible, Hashable {
    public var description: String {
        return "Begin: \(begin), End: \(end), Text: \(text)"
    }
}
