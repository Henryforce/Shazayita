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
