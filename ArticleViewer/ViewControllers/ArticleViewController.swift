//
//  ArticleViewController.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import UIKit

class ArticleViewController: UIViewController {
  private lazy var scrollView: UIScrollView = {
    UIScrollView()
  }()
  
  private lazy var containerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 15
    return stackView
  }()
  
  private lazy var articleImage: UIImageView = {
    let imageView = UIImageView()
    imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    imageView.backgroundColor = .lightGray
    return imageView
  }()
  
  private lazy var articleTitle: UILabel = {
    let articleTitle = UILabel()
    articleTitle.lineBreakMode = .byWordWrapping
    articleTitle.font = .boldSystemFont(ofSize: 15)
    return articleTitle
  }()
  
  private lazy var articleDate: UILabel = {
    let articleDate = UILabel()
    articleDate.lineBreakMode = .byWordWrapping
    articleDate.font = .systemFont(ofSize: 12)
    articleDate.textColor = .lightGray
    return articleDate
  }()
  
  private lazy var articleDescription: UILabel = {
    let articleDescription = UILabel()
    articleDescription.numberOfLines = 0
    articleDescription.lineBreakMode = .byWordWrapping
    articleDescription.font = .systemFont(ofSize: 15)
    return articleDescription
  }()
  
  var articleContent: String? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.populate()
      }
    }
  }
  
  let article: Article
  let sessionManager: SessionManager
  
  init(article: Article,
       sessionManager: SessionManager) {
    self.article = article
    self.sessionManager = sessionManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = article.title
    view.backgroundColor = .white
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Task { [weak self] in
      do {
        let articleDetails = try await sessionManager.fetchArticleDetails(articleId: article.id)
        self?.articleContent = articleDetails.content
      } catch {
        print(error)
      }
    }
  }
}

private extension ArticleViewController {
  func setup() {
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    
    scrollView.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
    
    containerView.addArrangedSubview(articleImage)
    containerView.addArrangedSubview(articleTitle)
    containerView.addArrangedSubview(articleDate)
    containerView.addArrangedSubview(articleDescription)
  }
  
  func populate() {
    guard let articleContent else { return }
    articleTitle.text = article.title
    articleDate.text = article.date
    articleDescription.text = articleContent
  }
}
