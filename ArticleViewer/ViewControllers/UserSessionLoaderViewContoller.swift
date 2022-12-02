//
//  UserSessionLoaderViewContoller.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 02/12/2022.
//

import UIKit

class UserSessionLoaderViewContoller: UIViewController {
  let coordinator: Coordinator
  let sessionManager: SessionManager
  
  init(coordinator: Coordinator,
       sessionManager: SessionManager) {
    self.coordinator = coordinator
    self.sessionManager = sessionManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.style = .large
    return activityIndicator
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    activityIndicator.startAnimating()
    guard sessionManager.retriveSession() else {
      coordinator.show(screen: .login)
      return
    }
    
    coordinator.show(screen: .articles)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    activityIndicator.stopAnimating()
  }
}
