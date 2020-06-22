//
//  YoutTubeModel.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import Foundation

struct PlaylistResponse: Decodable {
    let pageInfo: PageInfo
    let items: [PlaylistItem]
}

struct PageInfo: Decodable {
    let totalResults: Int
    let resultPerPage: Int
}

struct PlaylistItem: Decodable {
    let kind: String
    let etag: String
    let id: String
}
