//
//  YoutTubeModel.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import Foundation

struct ChannelPlaylistResponse: Decodable {
    let pageInfo: PageInfo
    let items: [ChannelPlaylist]
}

struct ChannelPlaylist: Decodable {
    let kind: String
    let etag: String
    let id: String
    let snippet: ChannelPlaylistSnippetItem?
}

struct ChannelPlaylistSnippetItem: Decodable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
}

struct Thumbnails: Decodable {
    let def: ThumbnailItem?
    let medium: ThumbnailItem?
    let high: ThumbnailItem?
    let standard: ThumbnailItem?
    let maxres: ThumbnailItem?

    private enum CodingKeys: String, CodingKey {
        case def = "default"
        case medium
        case high
        case standard
        case maxres
    }
}

struct ThumbnailItem: Codable {
    let url: URL
    let width: Int
    let height: Int
}
