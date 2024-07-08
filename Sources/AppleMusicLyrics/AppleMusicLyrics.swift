// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class AppleMusicLyrics {
    public var userToken: String
    var accessToken: String?
    var userStorefront: String?
    var lyricsResponseCache: LyricsResponse?
    var songIDCache: String?
    
    public init(userToken: String) {
        self.userToken = userToken
    }
    
    /// Retrieves synchronized lyrics for a given song ID.
    /// - Parameters:
    ///   - songID: The unique identifier of the song
    ///   - addSpace: A boolean flag to indicate whether to add spaces in lyrics
    /// - Returns: Synchronized lyrics if successful, nil otherwise
    public func getSynedLyrics(songID: String, addSpace: Bool) async -> SynedMusicLyrics? {
        do {
            let lyricsResponse = try await getLyricsResponseCache(songID: songID)
            var synedLyrics = try parseSynedLyricsResponse(lyricsResponse: lyricsResponse)
            
            if addSpace == true {
                let lyrics = try parseLyricsResponse(lyricsResponse: lyricsResponse)
                addSpaceToSynedLyrics(synedLyrics: &synedLyrics, lyrics: lyrics)
            }

            return synedLyrics
        } catch {
            print(error)
            return nil
        }
    }
    
    /// Retrieves lyrics for a given song ID.
    /// - Parameter songID: The unique identifier of the song
    /// - Returns: Lyrics if successful, nil otherwise
    public func getLyrics(songID: String) async -> MusicLyrics? {
        do {
            let lyricsResponse = try await getLyricsResponseCache(songID: songID)

            return try parseLyricsResponse(lyricsResponse: lyricsResponse)
        } catch {
            print(error)
            return nil
        }
    }
    
    /// Parses the synchronized lyrics response.
    /// - Parameter lyricsResponse: The response containing synchronized lyrics data
    /// - Returns: Synchronized lyrics object if successful, nil otherwise
    public func parseSynedLyricsResponse(lyricsResponse: LyricsResponse?) throws -> SynedMusicLyrics? {
        guard let synedLyricTTML = lyricsResponse?.data?.first?.relationships?.syllableLyrics?.data?.first?.attributes?.ttml else {
            throw AppleMusicLyricsError.LyricsNotFound
        }
        
        guard let data = synedLyricTTML.data(using: .utf8) else {
            throw AppleMusicLyricsError.LyricsNotFound
        }
        
        let parser = SynedLyricTTMLParser()
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = parser
        
        xmlParser.parse()
        return parser.getParsedLyric()
    }
    
    /// Parses the lyrics response.
    /// - Parameter lyricsResponse: The response containing lyrics data
    /// - Returns: Lyrics object if successful, nil otherwise
    public func parseLyricsResponse(lyricsResponse: LyricsResponse?) throws -> MusicLyrics? {
        guard let lyricTTML = lyricsResponse?.data?.first?.relationships?.lyrics?.data?.first?.attributes?.ttml else {
            throw AppleMusicLyricsError.LyricsNotFound
        }
        
        guard let data = lyricTTML.data(using: .utf8) else {
            throw AppleMusicLyricsError.LyricsNotFound
        }
        
        let parser = LyricTTMLParser()
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = parser
        
        xmlParser.parse()
        return parser.getParsedLyric()
    }
    
    func getLyricsResponseCache(songID: String) async throws -> LyricsResponse? {
        if songID != songIDCache || lyricsResponseCache == nil {
            let url = try await createAppleMusicLyricsURL(songID: songID)
            
            let responseData = try await getRequest(url: url, isAuthorize: true)
            lyricsResponseCache = try? JSONDecoder().decode(LyricsResponse.self, from: responseData)
            songIDCache = songID
        } 
        return lyricsResponseCache
    }
    
    func createAppleMusicLyricsURL(songID: String) async throws -> URL {
        if self.accessToken == nil {
            self.accessToken = await getAccessToken()
        }
        if self.userStorefront == nil {
            self.userStorefront = await getUserStorefront()
        }
        
        guard let userStorefront = self.userStorefront else {
            throw AppleMusicLyricsError.UserStorefrontNotFound
        }
        
        guard let url = URL(string: "https://amp-api.music.apple.com/v1/catalog/\(userStorefront)/songs/\(songID)?include[songs]=albums,lyrics,syllable-lyrics") else {
            throw AppleMusicLyricsError.CreateURLFail
        }
        
        return url
    }
    
    func addSpaceToSynedLyrics(synedLyrics: inout SynedMusicLyrics?, lyrics: MusicLyrics?) {
        guard let lyrics = lyrics, synedLyrics != nil else {
            return
        }
        
        for (lineIndex, line) in lyrics.lines.enumerated() {
            var text = line.text
            for (wordIndex, synedWord) in (synedLyrics?.lines[lineIndex].words ?? []).enumerated() {
                for char in synedWord.text {
                    if char == text.first {
                        text.removeFirst()
                    }
                    if text.first == " " {
                        synedLyrics?.lines[lineIndex].words[wordIndex].text.append(" ")
                        text.removeFirst()
                        break
                    }
                }
            }
            for (backgroundWordIndex, backgroundWord) in (synedLyrics?.lines[lineIndex].backgroundWords ?? []).enumerated() {
                for char in backgroundWord.text {
                    if char == text.first {
                        text.removeFirst()
                    }
                    if text.first == " " {
                        synedLyrics?.lines[lineIndex].backgroundWords[backgroundWordIndex].text.append(" ")
                        text.removeFirst()
                        break
                    }
                }
            }
        }
    }
}

extension AppleMusicLyrics {
    func getUserStorefront() async -> String? {
        do {
            guard let url = URL(string: "https://api.music.apple.com/v1/me/storefront") else {
                throw AppleMusicLyricsError.CreateURLFail
            }
            
            let responseData = try await getRequest(url: url, isAuthorize: true)
            let userStorefrontResponse = try? JSONDecoder().decode(UserStorefront.self, from: responseData)
            
            guard let userStorefront = userStorefrontResponse?.data?.first?.id else {
                throw AppleMusicLyricsError.UserStorefrontNotFound
            }
            
            return userStorefront
        } catch {
            print(error)
            return nil
        }
    }
    
    func getAccessToken() async -> String? {
        do {
            guard let url = URL(string: "https://music.apple.com") else {
                throw AppleMusicLyricsError.CreateURLFail
            }
            
            let responseData = try await getRequest(url: url, isAuthorize: false)
            let jsFileURL = try getJSFileURL(responseData: responseData)
            
            let tokenResponseData = try await getRequest(url: jsFileURL, isAuthorize: false)
            let responseText = String(data: tokenResponseData, encoding: .utf8)
            let regex = try Regex(#"(?=eyJh)(.*?)(?=")"#)
            
            guard let token = responseText?.matches(of: regex).first?.0 else {
                throw AppleMusicLyricsError.AccessTokenNotFound
            }
            
            return "Bearer " + String(token)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func getJSFileURL(responseData: Data) throws -> URL {
        let responseText = String(data: responseData, encoding: .utf8)
        let regex = try Regex("index.*.js")
        
        guard let jsFile = responseText?.matches(of: regex).first?.0 else {
            throw AppleMusicLyricsError.JSFileNotFound
        }
        
        guard let url = URL(string: "https://music.apple.com/assets/\(jsFile)") else {
            throw AppleMusicLyricsError.CreateURLFail
        }
        
        return url
    }
    
    private func getRequest(url: URL, isAuthorize: Bool) async throws -> Data {
        var request = URLRequest(url: url)
        if isAuthorize == true {
            guard let accessToken = self.accessToken else {
                throw AppleMusicLyricsError.AccessTokenNotFound
            }
            request.addValue("https://music.apple.com", forHTTPHeaderField: "origin")
            request.addValue("\(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("\(self.userToken)", forHTTPHeaderField: "Media-User-Token")
        }
        request.httpMethod = "GET"
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        return responseData
    }
    
    enum AppleMusicLyricsError: Error {
        case JSFileNotFound, CreateURLFail, AccessTokenNotFound, UserStorefrontNotFound, LyricsNotFound
    }
}
