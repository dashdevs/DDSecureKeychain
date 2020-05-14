//
//  KeychainAccessControlViewModel.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation
import SecureKeychain

enum KeychainAccessControlViewModel: Int {
    case biometryAny
    case biometryCurrentSet
    case devicePasscode
    case userPresence
    case applicationPassword
    case privateKeyUsage
    case and
    case or
    
    var value: KeychainItemAccessControl {
        switch self {
        case .biometryAny: return .biometryAny
        case .biometryCurrentSet: return .biometryCurrentSet
        case .devicePasscode: return .devicePasscode
        case .userPresence: return .userPresence
        case .applicationPassword: return .applicationPassword
        case .privateKeyUsage: return .privateKeyUsage
        case .and: return .and
        case .or: return .or
        }
    }
}
