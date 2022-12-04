//
//  ArticleTableViewCell.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
  static let identifier = "ArticleTableViewCell"
  private lazy var sideDetailsContainerView: UIView = {
    UIView()
  }()
  
  private lazy var articleImage: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .lightGray
    return imageView
  }()
  
  private lazy var articleDate: UILabel = {
    let articleDate = UILabel()
    articleDate.textAlignment = .center
    articleDate.numberOfLines = 0
    articleDate.lineBreakMode = .byWordWrapping
    articleDate.textColor = .black
    articleDate.font = .systemFont(ofSize: 12)
    return articleDate
  }()
  
  private lazy var textContainerView: UIView = {
    UIView()
  }()
  
  private lazy var articleTitle: UILabel = {
    let articleTitle = UILabel()
    articleTitle.lineBreakMode = .byWordWrapping
    articleTitle.numberOfLines = 0
    articleTitle.textColor = .black
    articleTitle.font = .systemFont(ofSize: 18)
    return articleTitle
  }()
  
  private lazy var articleDescription: UILabel = {
    let articleDescription = UILabel()
    articleDescription.numberOfLines = 0
    articleDescription.lineBreakMode = .byWordWrapping
    articleDescription.font = .systemFont(ofSize: 15)
    articleDescription.textColor = .black
    return articleDescription
  }()
  
  private var imageFetcher: ImageDataFetcher?
  private var article: Article? {
    didSet {
      populate()
      fetchImage()
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    articleImage.image = nil
    articleDate.text = nil
    articleTitle.text = nil
    articleDescription.text = nil
  }
  
  func update(article: Article, imageFetcher: ImageDataFetcher) {
    self.imageFetcher = imageFetcher
    self.article = article
  }
}

private extension ArticleTableViewCell {
  func commonInit() {
    selectionStyle = .none
    setupView()
    setupSideDetails()
    setupTexts()
  }
  
  func setupView() {
    backgroundColor = .clear
  }
  
  func setupSideDetails() {
    contentView.addSubview(sideDetailsContainerView)
    sideDetailsContainerView.translatesAutoresizingMaskIntoConstraints = false
    sideDetailsContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    sideDetailsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -10).isActive = true
    sideDetailsContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
    sideDetailsContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
    sideDetailsContainerView.addSubview(articleImage)
    articleImage.translatesAutoresizingMaskIntoConstraints = false
    articleImage.topAnchor.constraint(equalTo: sideDetailsContainerView.topAnchor, constant: 5).isActive = true
    articleImage.centerXAnchor.constraint(equalTo: sideDetailsContainerView.centerXAnchor).isActive = true
    articleImage.widthAnchor.constraint(equalTo: sideDetailsContainerView.widthAnchor, multiplier: 0.6).isActive = true
    articleImage.heightAnchor.constraint(equalTo: articleImage.widthAnchor).isActive = true
    
    sideDetailsContainerView.addSubview(articleDate)
    articleDate.translatesAutoresizingMaskIntoConstraints = false
    articleDate.topAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: 5).isActive = true
    articleDate.centerXAnchor.constraint(equalTo: sideDetailsContainerView.centerXAnchor).isActive = true
    articleDate.widthAnchor.constraint(equalTo: sideDetailsContainerView.widthAnchor).isActive = true
    articleDate.bottomAnchor.constraint(lessThanOrEqualTo: sideDetailsContainerView.bottomAnchor).isActive = true
  }
  
  func setupTexts() {
    contentView.addSubview(textContainerView)
    textContainerView.translatesAutoresizingMaskIntoConstraints = false
    textContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    textContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    textContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
    textContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
    textContainerView.addSubview(articleTitle)
    articleTitle.translatesAutoresizingMaskIntoConstraints = false
    articleTitle.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 5).isActive = true
    articleTitle.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor).isActive = true
    articleTitle.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -5).isActive = true
    
    textContainerView.addSubview(articleDescription)
    articleDescription.translatesAutoresizingMaskIntoConstraints = false
    articleDescription.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 5).isActive = true
    articleDescription.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor).isActive = true
    articleDescription.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -5).isActive = true
    articleDescription.bottomAnchor.constraint(lessThanOrEqualTo: textContainerView.bottomAnchor, constant: -15).isActive = true
  }
  
  func populate() {
    guard let article else { return }
    articleTitle.text = article.title
    articleDescription.text = article.summary
    articleDate.text = article.date
  }
  
  func fetchImage() {
    guard let imageUrl = article?.thumbnail,
          let imageFetcher else { return }
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
