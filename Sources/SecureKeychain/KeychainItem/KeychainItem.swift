//
//  KeychainItem.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import LocalAuthentication

public typealias KeychainItemAccessLevel = (accessibility: KeychainItemAccessibility, accessControl: [KeychainItemAccessControl]?, context: LAContext?)

/// Describes the basic actions when interacting with the keychain
public protocol KeychainItem {
    
    /// Returns all stored keys.
    var allKeys: [String] { get }
    
    /// This function deletes all items
    func clear()
    
    /// Storing value to encrypted keychain.
    func set(_ value: String?, for key: String, with accessLevel: KeychainItemAccessLevel?) throws
    
    /// Restoring a value from an encrypted keychain.
    func get(_ key: String, with context: LAContext?, for reason: String?) throws -> String
    
    /// Saving and restoring values through the subscript.
    subscript(key: String) -> String? { get set }
}
