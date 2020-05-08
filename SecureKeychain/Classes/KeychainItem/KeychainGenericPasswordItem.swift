//
//  KeychainGenericPasswordItem.swift
//
//  Copyright © 2018 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainGenericPasswordItem {
    public let query: [String : Any]
    
    public init(service: String, account: String, accessGroup: String? = nil) {
        var query: [String: Any] = [:]
        query[kSecClass as String] = KeychainItemType.genericPassword.value
        query[kSecAttrService as String] = service
        query[kSecAttrAccount as String] = account
        accessGroup.map { query[kSecAttrAccessGroup as String] = $0 }
        self.query = query
    }
    
    public func savePassword(_ password: String) throws {
        var query = self.query
        guard let data = password.data(using: .utf8) else { throw KeychainItemError.canNotCreateDataFromPassword }
        query[kSecValueData as String] = data
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case noErr:
            return
        case errSecDuplicateItem:
            throw KeychainItemError.itemAlreadyExist
        default:
            throw KeychainItemError.error(status: status)
        }
    }
}
