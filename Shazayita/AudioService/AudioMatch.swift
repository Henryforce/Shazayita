//
//  AudioMatch.swift
//  Shazayita
//
//  Created by Henry Javier Serrano Echeverria on 2/1/22.
//

import Foundation
import ShazamKit

struct AudioMatch {
    let shazamID: String
    let title: String
    let subtitle: String?
    let artist: String
    let genres: [String]
    let webURL: URL?
    let artworkURL: URL?
    let videoURL: URL?
}

extension AudioMatch {
    init?(from mediaItem: SHMediaItem) {
        // At least ID, title and artist need to be valid for a match
        guard let shazamID = mediaItem.shazamID,
              let title = mediaItem.title,
              let artist = mediaItem.artist else { return nil }
        
        self.shazamID = shazamID
        self.title = title
        self.subtitle = mediaItem.subtitle
        self.artist = artist
        self.genres = mediaItem.genres
        self.webURL = mediaItem.webURL
        self.artworkURL = mediaItem.artworkURL
        self.videoURL = mediaItem.videoURL
    }
}

extension AudioMatch {
    static let masterOfPuppets = AudioMatch(
        shazamID: "66427234",
        title: "Master of Puppets",
        subtitle: "Metallica",
        artist: "Metallica",
        genres: ["Metal", "Music", "Rock"],
        webURL: URL(string: "https://www.shazam.com/track/66427234/master-of-puppets?co=SG&offsetInMilliseconds=1414&timeSkew=-0.0023508668&trackLength=515240&startDate=2022-01-03T15:21:37.657Z"),
        artworkURL: URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/7f/9e/4c/7f9e4ccf-7770-525e-4662-f36cbf4956a9/00602557944389.rgb.jpg/800x800bb.jpg"),
        videoURL: URL(string: "https://music.apple.com/sg/music-video/master-of-puppets/1467912133")
    )
}
