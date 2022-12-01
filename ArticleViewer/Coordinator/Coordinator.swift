//
//  Coordinator.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import Foundation
import UIKit

protocol Coordinator {
  func show(screen: AppScreen)
  func push(screen: AppScreen)
}

class AppCoordinator: Coordinator {
  var navigationController: UINavigationController?
  
  func show(screen: AppScreen) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let vc = screen.make(withCoordinator: self)
      self.navigationController?.setViewControllers([vc], animated: true)
    }
  }
  
  func push(screen: AppScreen) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let vc = screen.make(withCoordinator: self)
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}
