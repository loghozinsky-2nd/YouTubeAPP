//
//  FeedViewController.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit
import RxSwift
import InfiniteLayout

class FeedViewController: UIViewController {
    
    let collectionView: RxInfiniteCollectionView = {
        let collectionView = RxInfiniteCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        return collectionView
    }()
    
    let bottomSheetPlayerViewController: BottomSheetPlayerViewController = {
        let viewController = BottomSheetPlayerViewController()
        
        return viewController
    }()
    
    private var viewModel: FeedViewPresenteble!
    var viewModelBuilder: FeedViewPresenteble.Builder!
    var coordinator: FeedCoordinator!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "asd")
        
        bindViewModel()
        
        setupLayout(in: collectionView, bottomSheetPlayerViewController.view)
    }
    
    private func bindViewModel() {
        viewModel = viewModelBuilder()
        
        viewModel.output.channelPlaylists
            .bind(to: collectionView.rx.items(cellIdentifier: "asd", cellType: UICollectionViewCell.self)) { row, data, cell in
                print("\(row)")
                cell.backgroundColor = .init(white: 1, alpha: 0.15)
            }
            .disposed(by: disposeBag)
        
        collectionView
            .rx
            .willDisplayCell
            .subscribe(onNext: { (cell, indexPath) in
                if indexPath.item == 0 {
                    print("willDisplay")
                    self.viewModel.output.channelPlaylists.bind { (items) in
                        let item = items.first!
                        self.viewModel.getPlaylistItems(playlistId: item.id)
                    }.disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
  
    private func setupLayout(in views: UIView ...) {
        view.addSubviews(views)
        view.backgroundColor = .black
        
        collectionView.fillSuperview()
    }

}
