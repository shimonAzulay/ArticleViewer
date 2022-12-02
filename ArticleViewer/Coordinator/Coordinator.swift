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
  let sessionManager: SessionManager
  
  init(sessionManager: SessionManager) {
    self.sessionManager = sessionManager
  }
  
  func show(screen: AppScreen) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let vc = self.make(screen)
      self.navigationController?.setViewControllers([vc], animated: true)
    }
  }
  
  func push(screen: AppScreen) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let vc = self.make(screen)
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

private extension AppCoordinator {
  func make(_ screen: AppScreen) -> UIViewController {
    switch screen {
    case .login:
      let vc = LoginViewController(coordinator: self,
                                   sessionManager: sessionManager)
      return vc
    case .articles:
      let vc = ArticlesViewController(coordinator: self,
                                      sessionManager: sessionManager)
      return vc
    case .article(let article):
      let vc = ArticleViewController(article: article,
                                     sessionManager: sessionManager)
      return vc
    }
  }
}
