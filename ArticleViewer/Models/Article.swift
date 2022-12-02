//
//  Article.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import Foundation

struct Article: Decodable {
  let id: Int?
  let thumbnail: String?
  let title: String
  let summary: String
  let date: String
  let content: String?
  let image: String?
  
  enum CodingKeys: String, CodingKey {
    case id, title, summary, date, content
    case thumbnail = "thumbnail_url"
    case image = "image_url"
  }
}
