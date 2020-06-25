//
//  PlaylistHeader.swift
//  YouTubeAPP
//
//  Created by iMac_4 on 25.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit
import RxDataSources

class PlaylistHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: self)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    func configure(with data: String) {
        titleLabel.text = data
        
        setupLayout(in: titleLabel)
    }
    
    private func setupLayout(in views: UIView ...) {
        titleLabel.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
}
