//
//  KeychainItemPassword.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

protocol KeychainItemPassword: KeychainItemStatusHandler {
    var query: [String : Any] { get set }
    func save(_ password: String?, for account: String, with accessibility: KeychainItemAccessibility?) throws
    func restore(for account: String) throws -> String
    func restoreAllAccounts() throws -> [String]
    func removeAllAccounts() throws
}

extension KeychainItemPassword {
    func save(_ password: String?, for account: String, with accessibility: KeychainItemAccessibility? = nil) throws {
        var query = self.query
        query[kSecAttrAccount as String] = account
        query[kSecAttrAccessible as String] = accessibility?.value
        
        var error: Unmanaged<CFError>?
        let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                     kSecAttrAccessibleWhenUnlocked,
                                                     [KeychainItemAccessControl.and.value, KeychainItemAccessControl.userPresence.value, KeychainItemAccessControl.applicationPassword.value],
                                                     &error)
        if let error = error?.takeRetainedValue() {
            print(error)
            throw error
        }
        query[kSecAttrAccessControl as String] = access
        
        guard let password = password else {
            try delete(with: query)
            return
        }
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            try update(password, with: query)
        case errSecItemNotFound:
            do {
                try add(password, with: query)
            } catch {
                guard accessibility != nil else { throw error }
                switch error as? KeychainItemError {
                case .alreadyExist:
                    query[kSecAttrAccessible as String] = nil
                    let status = SecItemCopyMatching(query as CFDictionary, nil)
                    throw status == errSecSuccess ? KeychainItemError.alreadyExistWithOtherAccessibility : error
                default: throw error
                }
            }
        default:
            try handle(status)
        }
    }
    
    func restore(for account: String) throws -> String {
        var query = self.query
        query[kSecAttrAccount as String] = account
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
    
    func restoreAllAccounts() throws -> [String] {
        var query = self.query
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = true
        var items: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &items)
        try handle(status)
        guard
            let existingItems = items as? [[String: Any]]
            else {
                throw KeychainItemError.unexpectedData
        }
        return existingItems.compactMap { $0[kSecAttrAccount as String] as? String }
    }
    
    func removeAllAccounts() throws {
        try delete(with: query)
    }
    
    private func add(_ password: String, with query: [String: Any]) throws {
        var query = query
        guard let passwordData = password.data(using: .utf8) else { throw KeychainItemError.canNotCreateDataFromPassword }
        query[kSecValueData as String] = passwordData
        let status = SecItemAdd(query as CFDictionary, nil)
        try handle(status)
    }
    
    private func update(_ password: String, with query: [String: Any]) throws {
        guard let passwordData = password.data(using: .utf8) else { throw KeychainItemError.canNotCreateDataFromPassword }
        let attributes: [String: Any] = [kSecValueData as String: passwordData]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        try handle(status)
    }
    
    private func delete(with query: [String: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)
        try handle(status)
    }
}
