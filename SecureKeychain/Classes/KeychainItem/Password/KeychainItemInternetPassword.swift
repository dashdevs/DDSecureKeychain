//
//  KeychainItemInternetPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainItemInternetPassword: KeychainItemPassword {
    var query: [String : Any]
    
    public init(server: String) {
        var query: [String: Any] = [:]
        query[kSecClass as String] = KeychainItemType.internetPassword.value
        query[kSecAttrServer as String] = server
        self.query = query
    }
}

extension KeychainItemInternetPassword: KeychainItem {
    public var allKeys: [String] { (try? restoreAllAccounts()) ?? [] }
    
    public func clear() { try? removeAllAccounts() }
    
    public subscript(key: String) -> String? {
        get { return try? restore(for: key) }
        set { try? save(newValue, for: key) }
    }
    
    @discardableResult
    public mutating func append(_ accessGroup: String?) -> KeychainItemInternetPassword {
        query[kSecAttrAccessGroup as String] = accessGroup
        return self
    }
    
    @discardableResult
    public mutating func append(_ accessibility: KeychainItemAccessibility?) -> KeychainItemInternetPassword {
        query[kSecAttrAccessible as String] = accessibility?.value
        return self
    }
}
