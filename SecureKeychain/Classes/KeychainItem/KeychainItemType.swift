//
//  KeychainItemType.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

enum KeychainItemType {
    case genericPassword
    case internetPassword
    case certificate
    case cryptographicKey
    case identity
    
    var value: CFString {
        switch self {
        case .genericPassword: return kSecClassGenericPassword
        case .internetPassword: return kSecClassInternetPassword
        case .certificate: return kSecClassCertificate
        case .cryptographicKey: return kSecClassKey
        case .identity: return kSecClassIdentity
        }
    }
}
