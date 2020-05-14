//
//  KeychainItemAccessControl.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public enum KeychainItemAccessControl {
    // Constraints
    case biometryAny
    case biometryCurrentSet
    case devicePasscode
    case userPresence
    // Conjunctions
    case and
    case or
    // Additional Options
    case applicationPassword
    case privateKeyUsage
    
    var value: SecAccessControlCreateFlags.Element {
        switch self {
        case .biometryAny:
            if #available(iOS 11.3, *) {
                return .biometryAny
            } else {
                return .touchIDAny
            }
        case .biometryCurrentSet:
            if #available(iOS 11.3, *) {
                return .biometryCurrentSet
            } else {
                return .touchIDCurrentSet
            }
        case .devicePasscode: return .devicePasscode
        case .userPresence: return .userPresence
        case .and: return .and
        case .or: return .or
        case .applicationPassword: return .applicationPassword
        case .privateKeyUsage: return .privateKeyUsage
        }
    }
}

extension Array where Element == KeychainItemAccessControl {
    var value: SecAccessControlCreateFlags {
        var flags = SecAccessControlCreateFlags()
        forEach { flags.insert($0.value) }
        return flags
    }
}
