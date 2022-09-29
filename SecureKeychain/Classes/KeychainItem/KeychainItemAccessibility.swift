//
//  KeychainItemAccessibility.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

/// Constants that provide item access to the keychain

public enum KeychainItemAccessibility {
    /// Item data can only be accessed once the device has been unlocked after a restart.
    /// This is recommended for items that need to be accesible by background applications.
    /// Items with this attribute will migrate to a new device when using encrypted backups.
    case afterFirstUnlock
    
    /// Item data can only be accessed once the device has been unlocked after a restart.
    /// This is recommended for items that need to be accessible by background applications.
    /// Items with this attribute will never migrate to a new device, so after a backup is restored to a new device these items will be missing.
    case afterFirstUnlockThisDeviceOnly
    
    /// Item data can only be accessed while the device is unlocked.
    /// This is recommended for items that only need to be accessible while the application is in the foreground and requires a passcode to be set on the device.
    /// Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing.
    /// This attribute will not be available on devices without a passcode.
    /// Disabling the device passcode will cause all previously protected items to be deleted.
    case whenPasscodeSetThisDeviceOnly
    
    /// Item data can only be accessed while the device is unlocked.
    /// This is recommended for items that only need be accesible while the application is in the foreground.
    /// Items with this attribute will migrate to a new device when using encrypted backups.
    case whenUnlocked
    
    /// Item data can only be accessed while the device is unlocked.
    /// This is recommended for items that only need be accesible while the application is in the foreground.
    /// Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing.
    case whenUnlockedThisDeviceOnly
    
    var value: CFString {
        switch self {
        case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock
        case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked
        case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
    }
}
