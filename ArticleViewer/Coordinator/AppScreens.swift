//
//  AppScreens.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import Foundation
import UIKit

enum AppScreen {
  case login
  case articles
  case article(Article)
}

extension AppScreen {
  func make(withCoordinator coordinator: Coordinator) -> UIViewController {
    switch self {
    case .login:
      let vc = LoginViewController()
      vc.coordinator = coordinator
      return vc
    case .articles:
      let vc = ArticlesViewController()
      vc.coordinator = coordinator
      return vc
    case .article(let article):
      let vc = ArticleViewController()
      vc.article = article
      return vc
    }
  }
}
