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
  
  var coordinator: Coordinator?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Articles"
    navigationItem.rightBarButtonItem  = logoutButton
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    articles = [Article(title: "AAA", summary: "AAAAA AAAAA", description: "AAAAA AAAAA AAAAA AAAAA AAAAA AAAAA AAAAA AAAAA AAAAA AAAAA AAAAA AAAAA", date: .now),
                Article(title: "BBBBB", summary: "BBBBB BBBBB", description: "BBBBB BBBBB BBBBB BBBBB BBBBB BBBBB BBBBB BBBBB BBBBB", date: .now)]
  }
  
  @objc func logoutButtonTapped() {
    coordinator?.show(screen: .login)
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
    coordinator?.push(screen: .article(article))
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
