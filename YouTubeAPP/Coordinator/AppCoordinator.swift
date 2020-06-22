//
//  AppCoordinator.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
  
  init(window: UIWindow) {
    self.window = window
  }
  
  private let window: UIWindow
  private let navigationController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  override func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    let feedCoordinator = FeedCoordinator(navigationController: navigationController)
    add(coordinator: feedCoordinator)
    
    feedCoordinator.start()
  }
  
}
