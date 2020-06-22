//
//  Coordinator.swift
//  YouTubeAPP
//
//  Created by iMac_1 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import Foundation

protocol Coordinator: class {
  var childs: [Coordinator] { get set }
  
  func start()
}

extension Coordinator {
  func add(coordinator: Coordinator) {
    childs.append(coordinator)
  }
  
  func remove(coordinator: Coordinator) {
    childs = childs.filter({ $0 !== coordinator })
  }
}

class BaseCoordinator: Coordinator {
  
  var childs = [Coordinator]()
  
  func start() {
    fatalError("Base Coordinator should be call from Child Coordinator")
  }
  
}
