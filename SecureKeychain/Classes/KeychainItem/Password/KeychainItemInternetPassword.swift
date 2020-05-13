//
//  KeychainItemInternetPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainItemInternetPassword: KeychainItemPassword {
    var query: [String : Any]
    
    public init(server: String, accessGroup: String? = nil) {
        var query: [String: Any] = [:]
        query[kSecClass as String] = KeychainItemType.internetPassword.value
        query[kSecAttrServer as String] = server
        accessGroup.map { query[kSecAttrAccessGroup as String] = $0 }
        self.query = query
    }
}

extension KeychainItemInternetPassword: KeychainItem {
    public var allKeys: [String] { (try? restoreAllAccounts()) ?? [] }
    
    public func clear() { try? removeAllAccounts() }
    
    public func set(_ value: String?, for key: String, with accessibility: KeychainItemAccessibility?) throws {
        try save(value, for: key, with: accessibility)
    }
    
    public subscript(key: String) -> String? {
        get { return try? restore(for: key) }
        set { try? save(newValue, for: key) }
    }
}
