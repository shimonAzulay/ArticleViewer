//
//  Article.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import Foundation

struct Article: Decodable {
  let id: Int?
  let title: String
  let summary: String
  let date: String
  let content: String?
}
