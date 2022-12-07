//
//  KeychainItemStatusHandler.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

protocol KeychainItemStatusHandler {
    func handle(_ status: OSStatus) throws
}

extension KeychainItemStatusHandler {
    func handle(_ status: OSStatus) throws {
        switch status {
        case errSecDuplicateItem: throw KeychainItemError.alreadyExist
        case errSecItemNotFound: throw KeychainItemError.notFound
        case noErr: return
        default: throw KeychainItemError.error(status: status)
        }
    }
}
