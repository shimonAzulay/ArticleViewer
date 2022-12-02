//
//  KeyChainManager.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 02/12/2022.
//

import Foundation

protocol KeychainManager {
  func save<V: Encodable>(encodable: V, service: String, account: String)
  func read<T: Decodable>(service: String, account: String) -> T?
  func delete(service: String, account: String)
}

/// Reference for this code can be found here:  https://swiftsenpai.com/development/persist-data-using-keychain/
class AppKeychainManager: KeychainManager {
  func save<V: Encodable>(encodable: V, service: String, account: String) {
    guard let data = try? JSONEncoder().encode(encodable) else {
      return
    }
    
    let query = [
      kSecValueData: data,
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account,
    ] as CFDictionary
    
    let status = SecItemAdd(query, nil)
    
    if status == errSecDuplicateItem {
      let query = [
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecClass: kSecClassGenericPassword,
      ] as CFDictionary
      
      let attributesToUpdate = [kSecValueData: data] as CFDictionary
      
      SecItemUpdate(query, attributesToUpdate)
    }
    
    if status != errSecSuccess {
      print("Failed to save to keychain: \(status)")
    }
  }
  
  func read<T: Decodable>(service: String, account: String) -> T? {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
      kSecReturnData: true
    ] as CFDictionary
    
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    
    guard let data = result as? Data,
          let decoded = try? JSONDecoder().decode(T.self, from: data) else { return nil }
    
    return decoded
  }
  
  func delete(service: String, account: String) {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
    ] as CFDictionary
    
    SecItemDelete(query)
  }
}
