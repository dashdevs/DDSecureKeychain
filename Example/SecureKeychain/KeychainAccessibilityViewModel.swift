//
//  KeychainAccessibilityViewModel.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import UIKit
import SecureKeychain

enum KeychainAccessibilityViewModel: Int, CaseIterable {
    case none
    case afterFirstUnlock
    case afterFirstUnlockThisDeviceOnly
    case whenPasscodeSetThisDeviceOnly
    case whenUnlocked
    case whenUnlockedThisDeviceOnly
    
    var title: String {
        switch self {
        case .none: return "None"
        case .afterFirstUnlock: return "After First Unlock"
        case .afterFirstUnlockThisDeviceOnly: return "After First Unlock This Device Only"
        case .whenPasscodeSetThisDeviceOnly: return "When Passcode Set This Device Only"
        case .whenUnlocked: return "When Unlocked"
        case .whenUnlockedThisDeviceOnly: return "When Unlocked This Device Only"
        }
    }
    
    var accessibilityValue: KeychainItemAccessibility? {
        switch self {
        case .none: return nil
        case .afterFirstUnlock: return .afterFirstUnlock
        case .afterFirstUnlockThisDeviceOnly: return .afterFirstUnlockThisDeviceOnly
        case .whenPasscodeSetThisDeviceOnly: return .whenPasscodeSetThisDeviceOnly
        case .whenUnlocked: return .whenUnlocked
        case .whenUnlockedThisDeviceOnly: return .whenUnlockedThisDeviceOnly
        }
    }
}
