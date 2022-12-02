//
//  ImageFetcher.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 02/12/2022.
//

import Foundation

enum ImageDataFetcherError: Error {
  case invalidUrl
}

protocol ImageDataFetcher {
  func fetchImage(url: String) async throws -> Data
}

actor ImageDataCache {
  private var cache = [String: Data]()
  
  func getItem(forKey key: String) -> Data? {
    cache[key]
  }

  func setItem(forKey key: String, item: Data) {
    cache[key] = item
  }
}


class AppImageDataFetcher: ImageDataFetcher {
  let cache = ImageDataCache()
  
  func fetchImage(url: String) async throws -> Data {
    if let imageData = await cache.getItem(forKey: url) {
      return imageData
    }
    
    guard let imageUrl = URL(string: url) else {
      throw ImageDataFetcherError.invalidUrl
    }
    
    let imageData = try Data(contentsOf: imageUrl)
    await cache.setItem(forKey: url, item: imageData)
    
    return imageData
  }
}
