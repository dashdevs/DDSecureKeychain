//
//  KeychainItemGenericPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainItemGenericPassword: KeychainItemPassword {
    var query: [String : Any]
    
    public init(service: String, accessGroup: String? = nil) {
        var query: [String: Any] = [:]
        query[kSecClass as String] = KeychainItemType.genericPassword.value
        query[kSecAttrService as String] = service
        accessGroup.map { query[kSecAttrAccessGroup as String] = $0 }
        self.query = query
    }
}

extension KeychainItemGenericPassword: KeychainItem {
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
