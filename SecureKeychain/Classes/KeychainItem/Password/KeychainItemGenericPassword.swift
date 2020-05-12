//
//  KeychainItemGenericPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainItemGenericPassword: KeychainItemPassword {
    var query: [String : Any]
    
    public init(service: String) {
        var query: [String: Any] = [:]
        query[kSecClass as String] = KeychainItemType.genericPassword.value
        query[kSecAttrService as String] = service
        self.query = query
    }
}

extension KeychainItemGenericPassword: KeychainItem {
    public var allKeys: [String] { (try? restoreAllAccounts()) ?? [] }
    
    public func clear() { try? removeAllAccounts() }
    
    public subscript(key: String) -> String? {
        get { return try? restore(for: key) }
        set { try? save(newValue, for: key) }
    }
    
    @discardableResult
    public mutating func append(_ accessGroup: String?) -> KeychainItemGenericPassword {
        query[kSecAttrAccessGroup as String] = accessGroup
        return self
    }
    
    @discardableResult
    public mutating func append(_ accessibility: KeychainItemAccessibility?) -> KeychainItemGenericPassword {
        query[kSecAttrAccessible as String] = accessibility?.value
        return self
    }
}
