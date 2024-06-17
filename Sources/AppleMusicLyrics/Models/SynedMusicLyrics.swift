//
//  SynedMusicLyrics.swift
//
//
//  Created by Elvis on 12/06/2024.
//

import Foundation

// MARK: - MusicLyrics
struct SynedMusicLyrics: Decodable, Equatable {
    var lines: [SynedLine]
}

extension SynedMusicLyrics: CustomStringConvertible {
    var description: String {
        var output = ""
        for line in self.lines {
            output += "\n\t\(line)"
        }
        return "Lyrics: \(output)"
    }
}

// MARK: - Line
struct SynedLine: Decodable, Equatable {
    var begin: TimeInterval
    var end: TimeInterval
    var words: [SynedWord]
    var backgroundWords: [SynedWord]
    
    enum CodingKeys: String, CodingKey {
        case begin
        case end
        case words
        case backgroundWords = "background"
    }
    
    init(begin: TimeInterval, end: TimeInterval, words: [SynedWord], backgroundWords: [SynedWord]) {
        self.begin = begin
        self.end = end
        self.words = words
        self.backgroundWords = backgroundWords
    }
    
    init(from decoder: any Decoder) throws {
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

extension SynedLine: CustomStringConvertible {
    var description: String {
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
struct SynedWord: Decodable, Equatable {
    var begin: TimeInterval
    var end: TimeInterval
    var text: String
    
    init(begin: TimeInterval, end: TimeInterval, text: String) {
        self.begin = begin
        self.end = end
        self.text = text
    }
    
    enum CodingKeys: CodingKey {
        case begin
        case end
        case text
    }
    
    init(from decoder: any Decoder) throws {
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

extension SynedWord: CustomStringConvertible {
    var description: String {
        return "Begin: \(begin), End: \(end), Text: \(text)"
    }
}
