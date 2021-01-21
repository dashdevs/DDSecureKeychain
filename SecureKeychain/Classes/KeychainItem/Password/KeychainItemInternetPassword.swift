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
    
    /// Returns all stored keys
    
    public var allKeys: [String] { (try? restoreAllAccounts()) ?? [] }
    
    /// This function deletes all items
    
    public func clear() { try? removeAllAccounts() }
    
    /// Storing value to encrypted keychain.
    ///
    /// - Parameters:
    ///   - value (optional): The value to store.
    ///   - key: The key to store value to.
    ///   - accessLevel (optional): Item access level.
    
    public func set(_ value: String?, for key: String, with accessLevel: KeychainItemAccessLevel?) throws {
        try save(value, for: key, with: accessLevel)
    }
    
    /// Restoring a value from an encrypted keychain.
    ///
    /// - Parameters:
    ///   - key: The key to store value to.
    ///   - context: Represents an authentication context.
    ///   - reason (optional): The reason to authentificate in native alert (only for read biometric encrypted values).
    
    public func get(_ key: String, with context: LAContext?, for reason: String?) throws -> String {
        try restore(key, with: context, for: reason)
    }
    
    /// Saving and restoring values through the subscript.
    
    public subscript(key: String) -> String? {
        get { try? restore(key) }
        set { try? save(newValue, for: key) }
    }
}
