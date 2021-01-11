//
//  KeychainItem.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public protocol KeychainItem {
    var allKeys: [String] { get }
    func clear()
    func set(_ value: String?, for key: String, with accessLevel: KeychainItemAccessLevel?) throws
    subscript(key: String) -> String? { get set }
}
