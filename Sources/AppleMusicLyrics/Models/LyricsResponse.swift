import Foundation

// MARK: - LyricsResponse
struct LyricsResponse: Codable {
    let data: [LyricsResponseDatum]?
}

// MARK: - LyricsResponseDatum
struct LyricsResponseDatum: Codable {
    let id, type, href: String?
    let attributes: PurpleAttributes?
    let relationships: Relationships?
}

// MARK: - PurpleAttributes
struct PurpleAttributes: Codable {
    let albumName: String?
    let hasTimeSyncedLyrics: Bool?
    let genreNames: [String]?
    let trackNumber, durationInMillis: Int?
    let releaseDate: String?
    let isVocalAttenuationAllowed, isMasteredForItunes: Bool?
    let isrc: String?
    let artwork: Artwork?
    let audioLocale, composerName: String?
    let url: String?
    let playParams: PurplePlayParams?
    let discNumber: Int?
    let hasCredits, isAppleDigitalMaster, hasLyrics: Bool?
    let audioTraits: [String]?
    let name: String?
    let previews: [Preview]?
    let artistName: String?
}

// MARK: - Artwork
struct Artwork: Codable {
    let width: Int?
    let url: String?
    let height: Int?
    let textColor3, textColor2, textColor4, textColor1: String?
    let bgColor: String?
    let hasP3: Bool?
}

// MARK: - PurplePlayParams
struct PurplePlayParams: Codable {
    let id, kind: String?
}

// MARK: - Preview
struct Preview: Codable {
    let url: String?
}

// MARK: - Relationships
struct Relationships: Codable {
    let albums: Albums?
    let lyrics: Lyrics?
    let artists: Albums?
    let syllableLyrics: Lyrics?

    enum CodingKeys: String, CodingKey {
        case albums, lyrics, artists
        case syllableLyrics = "syllable-lyrics"
    }
}

// MARK: - Albums
struct Albums: Codable {
    let href: String?
    let data: [AlbumsDatum]?
}

// MARK: - AlbumsDatum
struct AlbumsDatum: Codable {
    let id, type, href: String?
    let attributes: FluffyAttributes?
}

// MARK: - FluffyAttributes
struct FluffyAttributes: Codable {
    let copyright: String?
    let genreNames: [String]?
    let releaseDate, upc: String?
    let isMasteredForItunes: Bool?
    let artwork: Artwork?
    let url: String?
    let playParams: PurplePlayParams?
    let recordLabel: String?
    let trackCount: Int?
    let isCompilation, isPrerelease: Bool?
    let audioTraits: [String]?
    let isSingle: Bool?
    let name, artistName: String?
    let isComplete: Bool?
}

// MARK: - Lyrics
struct Lyrics: Codable {
    let href: String?
    let data: [LyricsDatum]?
}

// MARK: - LyricsDatum
struct LyricsDatum: Codable {
    let id, type: String?
    let attributes: TentacledAttributes?
}

// MARK: - TentacledAttributes
struct TentacledAttributes: Codable {
    let ttml: String?
    let playParams: FluffyPlayParams?
}

// MARK: - FluffyPlayParams
struct FluffyPlayParams: Codable {
    let id, kind, catalogID: String?
    let displayType: Int?

    enum CodingKeys: String, CodingKey {
        case id, kind
        case catalogID = "catalogId"
        case displayType
    }
}
