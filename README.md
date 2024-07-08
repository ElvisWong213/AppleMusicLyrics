# Apple Music Lyrics

## About this project

Get lyrics from Apple Music

## Usage

### Initialization


```swift
import AppleMusicLyrics

let music = AppleMusicLyrics(userToken:"USER TOKEN")
```

### SynedMusicLyrics resopnse

```swift
public struct SynedMusicLyrics: Codable, Equatable, Hashable {
    public var lines: [SynedLine]
}

public struct SynedLine: Codable, Equatable {
    public var begin: TimeInterval
    public var end: TimeInterval
    public var words: [SynedWord]
    public var backgroundWords: [SynedWord]
}

public struct SynedWord: Codable, Equatable {
    public var begin: TimeInterval
    public var end: TimeInterval
    public var text: String
}
```

Example

```swift
let synedLyrics = await music.getSynedLyrics(songID: "SONG ID", addSpace: true)

for line in synedLyrics.lines {
    for word in line.words {
        print(word.text)
    }
}
```

### MusicLyrics resopnse


```swift
public struct MusicLyrics: Codable, Hashable {
    public var lines: [Line]
}

public struct Line: Codable {
    public var begin: TimeInterval
    public var end: TimeInterval
    public var text: String
}
```

Example


```swift
let lyrics = await music.getLyrics(songID: "SONG ID")
for line in lyrics.lines {
    print(line.text)
}
```
