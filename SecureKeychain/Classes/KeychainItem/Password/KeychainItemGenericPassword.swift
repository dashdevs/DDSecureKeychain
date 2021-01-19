//
//  KeychainItemGenericPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import LocalAuthentication

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
    
    public func set(_ value: String?, for key: String, with accessLevel: KeychainItemAccessLevel?) throws {
        try save(value, for: key, with: accessLevel)
    }
    
    public func get(_ key: String, with context: LAContext?, for reason: String?) throws -> String {
        try restore(key, with: context, for: reason)
    }
    
    public subscript(key: String) -> String? {
        get { try? restore(key) }
        set { try? save(newValue, for: key) }
    }
}
