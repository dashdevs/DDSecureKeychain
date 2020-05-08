//
//  KeychainItem.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public protocol KeychainItem {
    subscript(key: String) -> String? { get set }
    var allKeys: [String] { get }
}
