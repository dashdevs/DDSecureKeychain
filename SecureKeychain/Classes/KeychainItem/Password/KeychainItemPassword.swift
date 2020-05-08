//
//  KeychainItemPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

protocol KeychainItemPassword: KeychainItemStatusHandler {
    var query: [String : Any] { get set }
    func save(_ password: String?) throws
    func restore() throws -> String
}

extension KeychainItemPassword {
    func save(_ password: String?) throws {
        guard let password = password else {
            try delete()
            return
        }
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
    
    func restore() throws -> String {
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
        
    private func add(_ password: String) throws {
        var query = self.query
        guard let passwordData = password.data(using: .utf8) else { throw KeychainItemError.canNotCreateDataFromPassword }
        query[kSecValueData as String] = passwordData
        let status = SecItemAdd(query as CFDictionary, nil)
        try handle(status)
    }
    
    private func update(_ password: String) throws {
        guard let passwordData = password.data(using: .utf8) else { throw KeychainItemError.canNotCreateDataFromPassword }
        let attributes: [String: Any] = [kSecValueData as String: passwordData]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        try handle(status)
    }
    
    private func delete() throws {
        let status = SecItemDelete(query as CFDictionary)
        try handle(status)
    }
}
