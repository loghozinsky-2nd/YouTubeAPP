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
    
    var channelPlaylists = BehaviorRelay<[ChannelPlaylist]>(value: [])
    var playlists = BehaviorRelay<[[PlaylistItem]]>(value: [[]])
    
    func getChannelPlaylists(part: String = "snippet", channelId: String = "UCE_M8A5yxnLfW0KghEeajjw", maxResults: String? = "25") {
        APIService.shared.getChannelPlaylists(part: part, channelId: channelId, maxResults: maxResults) { [weak self] (response) in
            self?.channelPlaylists.accept(response.items)
        }
    }
    func getPlaylistItems(part: String = "snippet", playlistId: String = "PLBCF2DAC6FFB574DE", maxResults: String? = "25") {
        APIService.shared.getPlaylistItems(part: part, playlistId: playlistId, maxResults: maxResults) { [weak self] (response) in
            print(self?.playlists)
        }
    }
  
}
