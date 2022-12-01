//
//  Article.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import Foundation

struct Article {
  static var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/YY"
    return dateFormatter
  }()
  
  let title: String
  let summary: String
  let description: String
  let date: Date
}

extension Date {
  var asString: String {
    Article.dateFormatter.string(from: self)
  }
}
