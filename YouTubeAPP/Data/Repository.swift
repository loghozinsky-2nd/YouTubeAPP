//
//  Repository.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import RxCocoa

class Repository {
  
    private init() {}
    
    static let shared = Repository()
    
    var playlistItems = BehaviorRelay<[PlaylistItem]>(value: [])
    
    func getPlaylistItems(playlistId: String = "PLBCF2DAC6FFB574DE", maxResults: String = "25") {
        APIService.shared.getPlaylist(playlistId: playlistId, maxResults: maxResults) {
            print(self)
        }
    }
  
}
