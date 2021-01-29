//
//  KeychainItem.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import LocalAuthentication

public typealias KeychainItemAccessLevel = (accessibility: KeychainItemAccessibility, accessControl: [KeychainItemAccessControl]?, context: LAContext?)

public protocol KeychainItem {
    var allKeys: [String] { get }
    func clear()
    func set(_ value: String?, for key: String, with accessLevel: KeychainItemAccessLevel?) throws
    func get(_ key: String, with context: LAContext?, for reason: String?) throws -> String
    subscript(key: String) -> String? { get set }
}
