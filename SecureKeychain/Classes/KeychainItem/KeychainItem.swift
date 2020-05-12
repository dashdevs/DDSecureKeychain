//
//  KeychainItem.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public protocol KeychainItem {
    var allKeys: [String] { get }
    func clear()
    subscript(key: String) -> String? { get set }
    
    mutating func append(_ accessGroup: String) -> Self
    mutating func append(_ accessibility: KeychainItemAccessibility) -> Self
}
