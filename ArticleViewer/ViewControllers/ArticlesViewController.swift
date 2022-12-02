//
//  ArticlesViewController.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import UIKit

class ArticlesViewController: UIViewController {
  private lazy var articleTableView: UITableView = {
    UITableView()
  }()
  
  private lazy var logoutButton: UIBarButtonItem = {
    let barButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutButtonTapped))
    return barButtonItem
  }()
  
  private var articles = [Article]() {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.articleTableView.reloadData()
      }
    }
  }
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Articles"
    navigationItem.rightBarButtonItem  = logoutButton
    view.backgroundColor = .white
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Task { [weak self] in
      do {
        self?.articles = try await sessionManager.fetchArticles()
      } catch {
        print(error)
      }
    }
  }
  
  @objc func logoutButtonTapped() {
    sessionManager.logout()
    coordinator.show(screen: .login)
  }
}

private extension ArticlesViewController {
  func setupTableView() {
    articleTableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(articleTableView)
    articleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    articleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    articleTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    articleTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    articleTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
    articleTableView.delegate = self
    articleTableView.dataSource = self
  }
}

extension ArticlesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let article = articles[indexPath.row]
    coordinator.push(screen: .article(article))
  }
}

extension ArticlesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let article = articles[indexPath.row]
    
    guard let reusedArticleCell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else {
      let articleCell = ArticleTableViewCell()
      articleCell.article = article
      return articleCell
    }

    reusedArticleCell.article = article
    return reusedArticleCell
  }
}
