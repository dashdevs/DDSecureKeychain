//
//  KeychainItemInternetPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import LocalAuthentication

/// Structure is designed to work with internet types of passwords.

public struct KeychainItemInternetPassword: KeychainItemPassword {
    
    ///Query dictionary is needed to add all the required attributes.
    
    var query: [String : Any]
    
    /// Initialize KeychainItemInternetPassword instance.
    ///
    /// - Parameters:
    ///   - server: Value for the key kSecAttrServer.
    ///   - accessGroup (optional): Value for the key kSecAttrAccessGroup.
    
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
