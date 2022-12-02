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
  let imageFetcher: ImageDataFetcher
  
  init(sessionManager: SessionManager,
       imageFetcher: ImageDataFetcher) {
    self.sessionManager = sessionManager
    self.imageFetcher = imageFetcher
  }
  
  func show(screen: AppScreen) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      guard let vc = self.make(screen) else { return }
      self.navigationController?.setViewControllers([vc], animated: true)
    }
  }
  
  func push(screen: AppScreen) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      guard let vc = self.make(screen) else { return }
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

private extension AppCoordinator {
  func make(_ screen: AppScreen) -> UIViewController? {
    switch screen {
    case .login:
      let vc = LoginViewController(coordinator: self,
                                   sessionManager: sessionManager)
      return vc
    case .articles:
      let vc = ArticlesViewController(coordinator: self,
                                      sessionManager: sessionManager,
                                      imageFetcher: imageFetcher)
      return vc
    case .article(let article):
      guard let articleId = article.id else { return nil }
      let vc = ArticleViewController(coordinator: self,
                                     sessionManager: sessionManager,
                                     imageFetcher: imageFetcher,
                                     articleId: articleId,
                                     articleTitle: article.title)
      return vc
    }
  }
}
