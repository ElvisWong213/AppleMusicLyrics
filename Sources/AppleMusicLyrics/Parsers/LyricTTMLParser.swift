//
//  LyricTTMLParser.swift
//
//
//  Created by Elvis on 16/06/2024.
//

import Foundation

class LyricTTMLParser: NSObject, XMLParserDelegate {
    private var lyric: MusicLyrics?
    private var line: Line?
    
    func parserDidStartDocument(_ parser: XMLParser) {
        lyric = MusicLyrics(lines: [])
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
            line = Line(begin: begin, end: end, text: "")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        line?.text += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "p" {
            guard let line = line else {
                return
            }
            lyric?.lines.append(line)
        }
    }
}

extension LyricTTMLParser {
    func getParsedLyric() -> MusicLyrics? {
        return self.lyric
    }
}
