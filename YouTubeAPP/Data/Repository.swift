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
    var playlists = BehaviorRelay<[FeedSection]>(value: [])
    
    func getChannelPlaylists(part: String = "snippet, contentDetails", channelId: String = "UCE_M8A5yxnLfW0KghEeajjw", maxResults: String? = "4") {
        APIService.shared.getChannelPlaylists(part: part, channelId: channelId, maxResults: maxResults) { [weak self] (response) in
            self?.playlists.accept(response.items.map({
                FeedSection(id: $0.id, header: $0.snippet.title, items: [])
            }))
            print(">> playlists.value: \(self?.playlists.value)")
        }
    }
    func getPlaylistItems(part: String = "snippet", playlistId: String = "PLBCF2DAC6FFB574DE", maxResults: String? = "25") {
        APIService.shared.getPlaylistItems(part: part, playlistId: playlistId, maxResults: maxResults) { [weak self] (response) in
            var arr = self?.playlists.value ?? []
            for (index, item) in arr.enumerated() {
                if item.id == playlistId {
                    arr[index].items = response.items
                }
            }
            
            self?.playlists.accept(arr)
        }
    }
  
}
