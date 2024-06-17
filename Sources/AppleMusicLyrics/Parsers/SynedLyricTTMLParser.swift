//
//  SynedLyricTTMLParser.swift
//  
//
//  Created by Elvis on 13/06/2024.
//

import Foundation

class SynedLyricTTMLParser: NSObject, XMLParserDelegate {
    private var lyric: SynedMusicLyrics?
    private var line: SynedLine?
    private var word: SynedWord?
    private var isForgroundLyric: Bool = true
    
    func parserDidStartDocument(_ parser: XMLParser) {
        lyric = SynedMusicLyrics(lines: [])
    }
    
//    func parserDidEndDocument(_ parser: XMLParser) {
//        guard let lyric = self.lyric else {
//            return
//        }
//        print(lyric)
//    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "p" {
            let begin = Converter.convertStringToTime(attributeDict["begin"])
            let end = Converter.convertStringToTime(attributeDict["end"])
            line = SynedLine(begin: begin, end: end, words: [], backgroundWords: [])
            isForgroundLyric = true
        }
        if elementName == "span" {
            if let backgroundTag = attributeDict["ttm:role"], backgroundTag == "x-bg" {
                isForgroundLyric = false
                return
            }
            let begin = Converter.convertStringToTime(attributeDict["begin"])
            let end = Converter.convertStringToTime(attributeDict["end"])
            word = SynedWord(begin: begin, end: end, text: "")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        word?.text += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "p" {
            guard let line = line else {
                return
            }
            lyric?.lines.append(line)
        }
        if elementName == "span" {
            guard let word = word else {
                return
            }
            if isForgroundLyric == true {
                line?.words.append(word)
            } else {
                line?.backgroundWords.append(word)
            }
            self.word = nil
        }
    }
}

extension SynedLyricTTMLParser {
    func getParsedLyric() -> SynedMusicLyrics? {
        return self.lyric
    }
}
