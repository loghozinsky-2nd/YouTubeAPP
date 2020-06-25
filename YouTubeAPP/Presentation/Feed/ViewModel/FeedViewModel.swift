//
//  FeedViewModel.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FeedViewPresenteble {
    typealias Builder = () -> FeedViewPresenteble
    typealias Output = (
        playlists: Observable<[FeedSection]>,
        ()
    )
    
    var output: Output { get }
    
    func getPlaylistItems(playlistId: String)
}

class FeedViewModel: FeedViewPresenteble {
    
    var output: Output
    
    let disposeBag = DisposeBag()
    
    init() {
        self.output = Output(
            playlists: Repository.shared.playlists.asObservable().catchErrorJustReturn([]),
            ()
        )
        
        process()
    }
    
    private func process() {
        output.playlists
            .subscribe()
            .disposed(by: disposeBag)
        
        Repository.shared.getChannelPlaylists()
    }
    
    func getPlaylistItems(playlistId: String) {
        Repository.shared.getPlaylistItems(playlistId: playlistId)
    }
    
}
