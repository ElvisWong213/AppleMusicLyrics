import XCTest
@testable import AppleMusicLyrics

final class AppleMusicLyricsTests: XCTestCase {
    func testGetAccessToken() async throws {
        let appleMusicLyrics = AppleMusicLyrics(userToken: "")
        let data = await appleMusicLyrics.getAccessToken()
        XCTAssertNotNil(data)
    }
    
    func testParseSynedLyricsResponse() async throws {
        let appleMusicLyrics = AppleMusicLyrics(userToken: "")
        
        // Test File 1
        guard let url = Bundle.module.url(forResource: "response", withExtension: "json"), let data = try? Data(contentsOf: url) else {
            XCTFail("No JSON File")
            return
        }
        let lyricsResponse = try? JSONDecoder().decode(LyricsResponse.self, from: data)
        
        let lyric1 = try appleMusicLyrics.parseSynedLyricsResponse(lyricsResponse: lyricsResponse)
        XCTAssertNotNil(lyric1)
        
        // Test File 2
        guard let url2 = Bundle.module.url(forResource: "response2", withExtension: "json"), let data2 = try? Data(contentsOf: url2) else {
            XCTFail("No JSON File")
            return
        }
        
        let lyricsResponse2 = try? JSONDecoder().decode(LyricsResponse.self, from: data2)
        let lyric2 = try appleMusicLyrics.parseSynedLyricsResponse(lyricsResponse: lyricsResponse2)
        XCTAssertNotNil(lyric2)
    }
    
    func testParseLyricsResponse() async throws {
        let appleMusicLyrics = AppleMusicLyrics(userToken: "")
        
        // Test File 1
        guard let url = Bundle.module.url(forResource: "response", withExtension: "json"), let data = try? Data(contentsOf: url) else {
            XCTFail("No JSON File")
            return
        }
        let lyricsResponse = try? JSONDecoder().decode(LyricsResponse.self, from: data)
        
        let lyric1 = try appleMusicLyrics.parseLyricsResponse(lyricsResponse: lyricsResponse)
        XCTAssertNotNil(lyric1)
        
        // Test File 2
        guard let url2 = Bundle.module.url(forResource: "response2", withExtension: "json"), let data2 = try? Data(contentsOf: url2) else {
            XCTFail("No JSON File")
            return
        }
        let lyricsResponse2 = try? JSONDecoder().decode(LyricsResponse.self, from: data2)
        
        let lyric2 = try appleMusicLyrics.parseLyricsResponse(lyricsResponse: lyricsResponse2)
        XCTAssertNotNil(lyric2)
    }
    
    func testAddSpaceToSynedLyrics() async throws {
        let appleMusicLyrics = AppleMusicLyrics(userToken: "")
        
        // Test File
        guard let url = Bundle.module.url(forResource: "response2", withExtension: "json"), let data = try? Data(contentsOf: url) else {
            XCTFail("No Test File")
            return
        }
        let lyricsResponse = try? JSONDecoder().decode(LyricsResponse.self, from: data)
        let lyric = try appleMusicLyrics.parseLyricsResponse(lyricsResponse: lyricsResponse)
        var synedlyric = try appleMusicLyrics.parseSynedLyricsResponse(lyricsResponse: lyricsResponse)
        
        appleMusicLyrics.addSpaceToSynedLyrics(synedLyrics: &synedlyric, lyrics: lyric)

        // Compare File
        guard let url2 = Bundle.module.url(forResource: "lyric2", withExtension: "json"), let data2 = try? Data(contentsOf: url2) else {
            XCTFail("No Compare File")
            return
        }
        let compareLyrics = try? JSONDecoder().decode(SynedMusicLyrics.self, from: data2)
        
        XCTAssertEqual(synedlyric, compareLyrics)
    }
}
