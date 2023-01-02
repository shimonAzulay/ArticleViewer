//
//  NetworkManager.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 02/12/2022.
//

import Foundation
import Combine

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

protocol Endpoint {
  func makeRequest(token: String?) -> URLRequest?
  func makeRequest<PAYLOAD: Encodable>(with payload: PAYLOAD?, token: String?) -> URLRequest?
}

enum NetworkManagerError: Error, CustomStringConvertible {
  case invalidEndpoint
  case invalidResponse
  case badResponse
  case unauthenticated
  case general
  
  var description: String {
    switch self {
    case .invalidEndpoint:
      return "Invalid endpoint"
    case .invalidResponse, .badResponse:
      return "Invalid response"
    case .unauthenticated:
      return "Unauthenticated"
    case .general:
      return "Unknown"
    }
  }
  
}

protocol NetworkManager {
  func publisher<DATA: Encodable, RESPONSE: Decodable>(endpoint: Endpoint, data: DATA?, token: String?) -> AnyPublisher<RESPONSE, NetworkManagerError>
  func publisher<RESPONSE: Decodable>(endpoint: Endpoint, token: String?) -> AnyPublisher<RESPONSE, NetworkManagerError>
}

enum ArticleViewerEndpoint: Endpoint {
  case login
  case articles
  case article(id: Int)
  
  func makeRequest(token: String?) -> URLRequest? {
    guard let url =  URL(string: "https://\(host)\(uri)") else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    return request
  }
  
  func makeRequest<PAYLOAD: Encodable>(with payload: PAYLOAD, token: String?) -> URLRequest? {
    guard var request = makeRequest(token: token),
          let jsonPayload = try? JSONEncoder().encode(payload) else { return nil }
    
    request.httpBody = jsonPayload
    return request
  }
  
  var host: String { "mobilecodetest.fws.io/" }
  var uri: String { "\(service)/\(resource)" }
  
  var service: String {
    switch self {
    case .login:
      return ""
    case .articles, .article:
      return "api/v1/"
    }
  }
  
  var resource: String {
    switch self {
    case .login:
      return "auth/token"
    case .articles:
      return "articles"
    case.article(let id):
      return "articles/\(id)"
    }
  }
  
  var httpMethod: HTTPMethod {
    switch self {
    case .login:
      return .post
    case .articles, .article:
      return .get
    }
  }
}

class ArticleViewerNetworkManager: NetworkManager {  
  func publisher<DATA: Encodable, RESPONSE: Decodable>(endpoint: Endpoint, data: DATA?, token: String?) -> AnyPublisher<RESPONSE, NetworkManagerError> {
    guard let request = endpoint.makeRequest(with: data, token: token) else {
      return Fail(error: .invalidEndpoint).eraseToAnyPublisher()
    }
    
    return dataTaskPublisher(request: request)
  }
  
  func publisher<RESPONSE: Decodable>(endpoint: Endpoint, token: String?) -> AnyPublisher<RESPONSE, NetworkManagerError> {
    guard let request = endpoint.makeRequest(token: token) else {
      return Fail(error: .invalidEndpoint).eraseToAnyPublisher()
    }
    
    return dataTaskPublisher(request: request)
  }
  
  private func dataTaskPublisher<RESPONSE: Decodable>(request: URLRequest) -> AnyPublisher<RESPONSE, NetworkManagerError> {
    return URLSession.shared.dataTaskPublisher(for: request)
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse else {
          throw URLError(.cannotParseResponse)
        }
        guard httpResponse.statusCode != 401 else {
          throw URLError(.userAuthenticationRequired)
        }
        
        guard (200..<300) ~= httpResponse.statusCode else {
          throw URLError(.badServerResponse)
        }
        
        return element.data
      }
      .decode(type: RESPONSE.self, decoder: JSONDecoder())
      .mapError { error -> NetworkManagerError in
        if let error = error as? URLError {
          switch error.code {
          case .userAuthenticationRequired:
            return .unauthenticated
          case .badServerResponse:
            return .badResponse
          case .cannotParseResponse:
            return .invalidResponse
          default:
            return .general
          }
        }
        
        return .invalidResponse
      }
      .eraseToAnyPublisher()
  }
}
