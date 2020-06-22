//
//  FeedCoordinator.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit

class FeedCoordinator: BaseCoordinator {
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  private var navigationController: UINavigationController
  private var viewController = FeedViewController()
  
  override func start() {
    viewController.viewModelBuilder = {
      FeedViewModel()
    }
//    viewController.coordinator = self
    
    navigationController.viewControllers = [viewController]
    setupNavigationBar()
  }
  
  private func setupNavigationBar() {
    navigationController.navigationBar.prefersLargeTitles = true
    viewController.title = "YouTube API"
  }
  
}
