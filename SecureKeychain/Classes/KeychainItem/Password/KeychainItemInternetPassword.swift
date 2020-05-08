//
//  KeychainItemInternetPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainItemInternetPassword: KeychainItemPassword {
    public let query: [String : Any]
    
    public init(server: String, account: String, accessGroup: String? = nil) {
        var query: [String: Any] = [:]
        query[kSecClass as String] = KeychainItemType.internetPassword.value
        query[kSecAttrServer as String] = server
        query[kSecAttrAccount as String] = account
        accessGroup.map { query[kSecAttrAccessGroup as String] = $0 }
        self.query = query
    }
}
