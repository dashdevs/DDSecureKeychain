//
//  KeychainItemGenericPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainItemGenericPassword: KeychainItemPassword {
    var query: [String : Any]
    
    public init(service: String, account: String, accessGroup: String? = nil) {
        var query: [String: Any] = [:]
        query[kSecClass as String] = KeychainItemType.genericPassword.value
        query[kSecAttrService as String] = service
        query[kSecAttrAccount as String] = account
        accessGroup.map { query[kSecAttrAccessGroup as String] = $0 }
        self.query = query
    }
}

extension KeychainItemGenericPassword: KeychainItem {
    public subscript(key: String?) -> String? {
        get { return try? restore() }
        set { try? save(newValue) }
    }
}
