//
//  PlaylistItemsResponse.swift
//  YouTubeAPP
//
//  Created by iMac_4 on 24.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import Foundation

struct PlaylistItemsResponse: Decodable {
    let pageInfo: PageInfo
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
    
}
