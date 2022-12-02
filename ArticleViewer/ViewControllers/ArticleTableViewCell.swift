//
//  ArticleTableViewCell.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
  static let identifier = "ArticleTableViewCell"
  var article: Article? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.populate()
      }
    }
  }
  
  private lazy var sideDetailsContainerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  private lazy var articleImage: UIImageView = {
    let imageView = UIImageView()
    imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    imageView.backgroundColor = .lightGray
    return imageView
  }()
  
  private lazy var articleDate: UILabel = {
    let articleDate = UILabel()
    articleDate.textAlignment = .center
    articleDate.lineBreakMode = .byWordWrapping
    articleDate.font = .systemFont(ofSize: 10)
    return articleDate
  }()
  
  private lazy var textContainerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  private lazy var articleTitle: UILabel = {
    let articleTitle = UILabel()
    articleTitle.lineBreakMode = .byWordWrapping
    articleTitle.font = .systemFont(ofSize: 15)
    return articleTitle
  }()
  
  private lazy var articleDescription: UILabel = {
    let articleDescription = UILabel()
    articleDescription.numberOfLines = 0
    articleDescription.lineBreakMode = .byWordWrapping
    articleDescription.font = .systemFont(ofSize: 10)
    return articleDescription
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupSideDetails()
    setupTexts()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    articleImage.image = nil
    articleDate.text = nil
    articleTitle.text = nil
    articleDescription.text = nil
  }
}

private extension ArticleTableViewCell {
  func setupView() {
    contentView.backgroundColor = .white
  }
  
  func setupSideDetails() {
    contentView.addSubview(sideDetailsContainerView)
    sideDetailsContainerView.translatesAutoresizingMaskIntoConstraints = false
    sideDetailsContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    sideDetailsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
    sideDetailsContainerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5).isActive = true
    sideDetailsContainerView.addArrangedSubview(articleImage)
    sideDetailsContainerView.addArrangedSubview(articleDate)
  }
  
  func setupTexts() {
    contentView.addSubview(textContainerView)
    textContainerView.translatesAutoresizingMaskIntoConstraints = false
    textContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    textContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
    textContainerView.leadingAnchor.constraint(equalTo: sideDetailsContainerView.trailingAnchor, constant: 5).isActive = true
    textContainerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5).isActive = true
    textContainerView.addArrangedSubview(articleTitle)
    textContainerView.addArrangedSubview(articleDescription)
  }
  
  func populate() {
    guard let article else { return }
    articleTitle.text = article.title
    articleDescription.text = article.summary
    articleDate.text = article.date
  }
}
