//
//  LoginBody.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 02/12/2022.
//

import Foundation

struct Login: Encodable {
  let username: String
  let password: String
  let grantType: String
  
  enum CodingKeys: String, CodingKey {
    case username, password
    case grantType = "grant_type"
  }
}

struct LoginDetails: Codable {
  let accessToken: String
  let refreshToken: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
}
