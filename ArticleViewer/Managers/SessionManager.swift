//
//  SessionManager.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 02/12/2022.
//

import Foundation
import Combine

protocol SessionManager {
  func retriveSession() -> Bool
  func login(username: String, password: String) async throws
  func fetchArticles() async throws -> [Article]
  func fetchArticleDetails(articleId: Int) async throws -> Article
  func logout()
}

class ArticleViewerSessionManager: SessionManager {
  var loginDetails: LoginDetails?
  let networkManager: NetworkManager
  let keychainManager: KeychainManager
  
  init(networkManager: NetworkManager,
       keychainManager: KeychainManager) {
    self.networkManager = networkManager
    self.keychainManager = keychainManager
  }
  
  func retriveSession() -> Bool {
    guard let loginDetails: LoginDetails = keychainManager.read(service: "access-token", account: "mobilecodetest") else {
      return false
    }
    
    self.loginDetails = loginDetails
    return true
  }
  
  func login(username: String, password: String) async throws {
    try await loginDetails = loginAsync(username: username, password: password)
    keychainManager.save(encodable: loginDetails, service: "access-token", account: "mobilecodetest")
  }
  
  func fetchArticles() async throws -> [Article] {
    try await withCheckedThrowingContinuation { [weak self] continuation in
      var cancellable: AnyCancellable?
      cancellable = self?.networkManager.publisher(endpoint: ArticleViewerEndpoint.articles, token: loginDetails?.accessToken)
        .sink { result in
          switch result {
          case .finished:
            break
          case let .failure(error):
            continuation.resume(throwing: error)
          }
          cancellable?.cancel()
        } receiveValue: { (response: [Article]) in
          continuation.resume(with: .success(response))
        }
    }
  }
  
  func fetchArticleDetails(articleId: Int) async throws -> Article {
    try await withCheckedThrowingContinuation { [weak self] continuation in
      var cancellable: AnyCancellable?
      cancellable = self?.networkManager.publisher(endpoint: ArticleViewerEndpoint.article(id: articleId), token: loginDetails?.accessToken)
        .sink { result in
          switch result {
          case .finished:
            break
          case let .failure(error):
            continuation.resume(throwing: error)
          }
          cancellable?.cancel()
        } receiveValue: { (response: Article) in
          continuation.resume(with: .success(response))
        }
    }
  }
  
  private func loginAsync(username: String, password: String) async throws -> LoginDetails {
    try await withCheckedThrowingContinuation { [weak self] continuation in
      var cancellable: AnyCancellable?
      let payload = Login(username: username, password: password, grantType: "password")
      cancellable = self?.networkManager.publisher(endpoint: ArticleViewerEndpoint.login, data: payload, token: nil)
        .sink { result in
          switch result {
          case .finished:
            break
          case let .failure(error):
            continuation.resume(throwing: error)
          }
          cancellable?.cancel()
        } receiveValue: { (response: LoginDetails) in
          continuation.resume(with: .success(response))
        }
    }
   
  }
  
  func logout() {
    keychainManager.delete(service: "access-token", account: "mobilecodetest")
    loginDetails = nil
  }
}

