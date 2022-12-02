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
  
  private lazy var articleTitleLabel: UILabel = {
    let articleTitle = UILabel()
    articleTitle.numberOfLines = 0
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
    
  var article: Article? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.populate()
      }
      
      fetchImage()
    }
  }
  
  let coordinator: Coordinator
  let sessionManager: SessionManager
  let imageFetcher: ImageDataFetcher
  var articleTitle: String?
  let articleId: Int
  
  init(coordinator: Coordinator,
       sessionManager: SessionManager,
       imageFetcher: ImageDataFetcher,
       articleId: Int,
       articleTitle: String?) {
    self.coordinator = coordinator
    self.sessionManager = sessionManager
    self.imageFetcher = imageFetcher
    self.articleId = articleId
    self.articleTitle = articleTitle
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = articleTitle
    view.backgroundColor = .white
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Task { [weak self] in
      do {
        self?.article = try await sessionManager.fetchArticleDetails(articleId: articleId)
      } catch {
        if let networkManagerError = error as? NetworkManagerError,
           networkManagerError == NetworkManagerError.unauthenticated {
          sessionManager.logout()
          coordinator.show(screen: .login)
          return
        }
        
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
    containerView.addArrangedSubview(articleTitleLabel)
    containerView.addArrangedSubview(articleDate)
    containerView.addArrangedSubview(articleDescription)
  }
  
  func populate() {
    guard let article else { return }
    articleTitleLabel.text = article.title
    articleDate.text = article.date
    articleDescription.text = article.content
  }
  
  func fetchImage() {
    guard let imageUrl = article?.image else { return }
    Task { @MainActor [weak self] in
      do {
        let imageData = try await imageFetcher.fetchImage(url: imageUrl)
        self?.articleImage.image = UIImage(data: imageData)
      } catch {
        print(error)
      }
    }
  }
}
