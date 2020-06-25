//
//  PlaylistItemCollectionViewCell.swift
//  YouTubeAPP
//
//  Created by iMac_4 on 25.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit

class PlaylistItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: self)
    
    var data: FeedSection.Item!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    func configure(with data: FeedSection.Item) {
        self.data = data
        titleLabel.text = data.snippet.title
        titleLabel.textColor = .white
        
        setupLayout(in: titleLabel)
    }
    
    private func setupLayout(in views: UIView ...) {
        addSubviews(views)
        
        backgroundColor = .init(white: 1, alpha: 0.15)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
}
