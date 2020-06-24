//
//  Model.swift
//  YouTubeAPP
//
//  Created by iMac_4 on 24.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit

struct StateOffset {
    var state: State
    var offset: CGFloat
    
    private let fullScreenOffset = UIScreen.main.bounds.height - 150
    private var openedOffset: CGFloat = UIScreen.main.bounds.height * 0.5
    private let closedOffset: CGFloat = 100
    private let hiddenOffset: CGFloat = 50
    
    init(state: State) {
        switch state {
        case .fullScreen:
            self.offset = fullScreenOffset
            self.state =  .fullScreen
        case .opened:
            self.offset = openedOffset
            self.state = .opened
        case .closed:
            self.offset = closedOffset
            self.state = .closed
        default:
            self.offset = hiddenOffset
            self.state = .hidden
        }
    }
    
    init?(offset: CGFloat = 100) {
        let offset = offset >= 100 ? offset : 150
        switch offset {
        case 50 ..< openedOffset:
            self.offset = 100
            self.state = .closed
        default:
            self.offset = 50
            self.state = .hidden
        }
    }
}
