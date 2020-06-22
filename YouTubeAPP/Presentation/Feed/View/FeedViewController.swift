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
    
    private var viewModel: FeedViewPresenteble!
    var viewModelBuilder: FeedViewPresenteble.Builder!
    var coordinator: FeedCoordinator!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
        
        setupLayout(in: collectionView)
    }
    
    private func bindViewModel() {
        viewModel = viewModelBuilder()
    }
  
    private func setupLayout(in views: UIView ...) {
        view.backgroundColor = .black
        
        collectionView.fillSuperview()
    }

}
