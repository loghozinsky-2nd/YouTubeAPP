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
        playlists: Observable<[PlaylistItem]>,
        ()
    )
    
    var output: Output { get }
}

class FeedViewModel: FeedViewPresenteble {
    
    var output: Output
    
    let disposeBag = DisposeBag()
    
    init() {
        self.output = Output(
            playlists: Repository.shared.playlistItems.asObservable().catchErrorJustReturn([]),
            ()
        )
        
        process()
    }
    
    private func process() {
        Repository.shared.getPlaylistItems()
    }
    
}
