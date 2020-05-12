//
//  KeychainItemAccessControl.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public struct KeychainItemAccessControl {
    public enum Constraint {
        case biometryAny
        case biometryCurrentSet
        case devicePasscode
        case userPresence
        
        var value: SecAccessControlCreateFlags {
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
            }
        }
    }
    
    public enum Conjunction {
        case and
        case or
        
        var value: SecAccessControlCreateFlags {
            switch self {
            case .and: return .and
            case .or: return .or
            }
        }
    }
    
    public enum AdditionalOption {
        case applicationPassword
        case privateKeyUsage
        
        var value: SecAccessControlCreateFlags {
            switch self {
            case .applicationPassword: return .applicationPassword
            case .privateKeyUsage: return .privateKeyUsage
            }
        }
    }
}
