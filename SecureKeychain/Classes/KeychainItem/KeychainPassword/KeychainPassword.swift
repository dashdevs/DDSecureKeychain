//
//  KeychainPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public protocol KeychainPassword: KeychainItemStatusHandler {
    var query: [String : Any] { get }
    func save(_ password: String) throws
    func restore() throws -> String
    func delete() throws
}

extension KeychainPassword {
    public func save(_ password: String) throws {
        var query = self.query
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            try update(password)
        case errSecItemNotFound:
            try add(password)
        default:
            try handle(status)
        }
    }
    
    public func restore() throws -> String {
        var query = self.query
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        try handle(status)
        guard
            let passwordData = item as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else {
                throw KeychainItemError.unexpectedData
        }
        return password
    }
    
    public func delete() throws {
        let status = SecItemDelete(query as CFDictionary)
        try handle(status)
    }
    
    func add(_ password: String) throws {
        var query = self.query
        guard let passwordData = password.data(using: .utf8) else { throw KeychainItemError.canNotCreateDataFromPassword }
        query[kSecValueData as String] = passwordData
        let status = SecItemAdd(query as CFDictionary, nil)
        try handle(status)
    }
    
    func update(_ password: String) throws {
        guard let passwordData = password.data(using: .utf8) else { throw KeychainItemError.canNotCreateDataFromPassword }
        let attributes: [String: Any] = [kSecValueData as String: passwordData]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        try handle(status)
    }
}
