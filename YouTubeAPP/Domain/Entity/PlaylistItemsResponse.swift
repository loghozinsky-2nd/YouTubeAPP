//
//  PlaylistItemsResponse.swift
//  YouTubeAPP
//
//  Created by iMac_4 on 24.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import Foundation
import RxDataSources

struct PlaylistItemsResponse: Decodable {
    let pageInfo: PageInfo
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
    let id: String
    let snippet: PlaylistItemContentDetails
}

struct PlaylistItemContentDetails: Decodable {
    let title: String
    let description: String
    let position: Int
    let publishedAt: String
    let thumbnails: Thumbnails
    let resourceId: VideoDetails
}

struct VideoDetails: Decodable {
    let kind: String
    let videoId: String
}

struct FeedSection {
    var id: String
    var header: String
    var items: [Item]
}
extension FeedSection: SectionModelType {
    typealias Item = PlaylistItem

    init(original: FeedSection, items: [Item]) {
        self = original
        self.items = items
    }
}
