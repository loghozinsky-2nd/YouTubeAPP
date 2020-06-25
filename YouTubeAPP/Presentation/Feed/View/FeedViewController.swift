//
//  FeedViewController.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import InfiniteLayout

class FeedViewController: UIViewController {
    
    let collectionView: RxInfiniteCollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        var screen = UIScreen.main.bounds
        collectionLayout.itemSize = CGSize(width: screen.size.height / 2.4, height: screen.size.height / 5)
        collectionLayout.scrollDirection = .horizontal
        
        let collectionView = RxInfiniteCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    let bottomSheetPlayerViewController: BottomSheetPlayerViewController = {
        let viewController = BottomSheetPlayerViewController()
        
        return viewController
    }()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<FeedSection>(configureCell: {
        (dataSource, collectionView, indexPath, item) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistItemCollectionViewCell.reuseIdentifier, for: indexPath) as! PlaylistItemCollectionViewCell
        cell.configure(with: item)
        cell.backgroundColor = {
            switch indexPath.section {
            case 1: return .red
            case 2: return .blue
            case 3: return .white
            default: return .orange
            }
        }()
        
        return cell
    })

    private var viewModel: FeedViewPresenteble!
    var viewModelBuilder: FeedViewPresenteble.Builder!
    var coordinator: FeedCoordinator!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(PlaylistItemCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistItemCollectionViewCell.reuseIdentifier)
        collectionView.register(PlaylistHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderView.reuseIdentifier)
        
        bindViewModel()
        bindViewModelToCollectionView()
        
        setupLayout(in: collectionView, bottomSheetPlayerViewController.view)
    }

    private func bindViewModelToCollectionView(){
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderView.reuseIdentifier, for: indexPath) as! PlaylistHeaderView
            view.configure(with: dataSource.sectionModels[indexPath.section].header)
            
            return view
        }
        
        collectionView
            .rx
            .willDisplaySupplementaryView
            .subscribe(onNext: { (view, type, indexPath) in
                fatalError()
            })
            .disposed(by: disposeBag)
        
        
        collectionView
            .rx
            .willDisplayCell
            .subscribe(onNext: { (cell, indexPath) in
                
            })
            .disposed(by: disposeBag)
        
        collectionView
            .rx
            .itemSelected
            .subscribe { [weak self] (event) in
                print(event.element)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.playlists
            .bind(to: collectionView
                .rx
                .items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.playlists
            .bind(onNext: { items in
                _ = items.map({ [weak self] (item) in
                    if item.items.isEmpty {
                        self?.viewModel.getPlaylistItems(playlistId: item.id)
                    }
                })
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel = viewModelBuilder()
    }
  
    private func setupLayout(in views: UIView ...) {
        view.addSubviews(views)
        view.backgroundColor = .black
        
        collectionView.fillSuperview()
    }

}
