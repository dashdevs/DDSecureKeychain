//
//  SecureKeychain.swift
//
//  Copyright © 2018 dashdevs.com. All rights reserved.
//

import LocalAuthentication

public enum SecureKeychainError: Error {
    case accessibilityNotSpecified
    case authenticationPolicyNotSpecified
}

public class SecureKeychain {
    private var securePersistor: KeychainItem
    private var defaultAccessibility: KeychainItemAccessibility?
    private var defaultAuthenticationPolicy: KeychainItemAccessControl?
    
    /// Initialize SecureKeychain instance.
    ///
    /// - Parameters:
    ///   - keychain: Associated with keychain item protocol.
    ///   - accessibility (optional): The default accessibility value for keychain items.
    ///   - authenticationPolicy (optional): The default authentication Policy for keychain items.
    
    public init(keychain: KeychainItem, accessibility: KeychainItemAccessibility? = nil, authenticationPolicy: KeychainItemAccessControl? = nil) {
        defaultAccessibility = accessibility
        defaultAuthenticationPolicy = authenticationPolicy
        securePersistor = keychain
    }
    
    // MARK: - Private
    
    /// Storing value to encrypted keychain.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to store value to.
    ///   - keychain: The keychain to store.
    ///   - accessibility: The accessibility level for keychain item.
    ///   - policy: The authentication policy for keychain item.
    ///   - context: Represents an authentication context.
    
    private func setEncryptedValue(_ value: String, for key: String, accessibility: KeychainItemAccessibility, with policy: KeychainItemAccessControl, context: LAContext) throws {
        try securePersistor.set(value, for: key, with: KeychainItemAccessLevel(accessibility: accessibility, accessControl: [policy], context: context))
    }
    
    
    // MARK: - Public
    
    /// Store value to password encrypted keychain.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to store value to.
    ///   - password: The password for encryption.
    ///   - accessibility (optional): The accessibility level for keychain item. If not specified default accessibility level will be used.
    /// - Throws: Throws an error if both accessibility level for key and default accessibility level are not specified.
    
    public func storeToPasswordProtectedKeychain(value: String, for key: String, with password: String, accessibility: KeychainItemAccessibility? = nil) throws {
        guard let accessability = accessibility ?? defaultAccessibility else {
            throw SecureKeychainError.accessibilityNotSpecified
        }
        securePersistor[key] = nil
        let context = LAContext()
        context.setCredential(password.data(using: String.Encoding.utf8), type: .applicationPassword)
        try setEncryptedValue(value, for: key, accessibility: accessability, with: .applicationPassword, context: context)
    }
    
    /// Store value to biometric encrypted keychain.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to store value to.
    ///   - accessibility (optional): The accessibility level for keychain item. If not specified default accessibility level will be used.
    ///   - authenticationPolicy (optional): The authentication policy for keychain item. If not specified default authentication policy level will be used.
    /// - Throws: Throws an error if both accessibility level for key and default accessibility level are not specified, or both authentication policy level for key and default authentication policy level are not specified.
    
    public func storeToBiometricProtectedKeychain(value: String, for key: String, accessibility: KeychainItemAccessibility? = nil, authenticationPolicy: KeychainItemAccessControl? = nil) throws {
        guard let accessability = accessibility ?? defaultAccessibility else {
             throw SecureKeychainError.accessibilityNotSpecified
        }
        guard let authenticationPolicy = authenticationPolicy ?? defaultAuthenticationPolicy else {
            throw SecureKeychainError.authenticationPolicyNotSpecified
        }
        securePersistor[key] = nil
        let context = LAContext()
        try setEncryptedValue(value, for: key, accessibility: accessability, with: authenticationPolicy, context: context)
    }
    
    /// Store value to unencrypted keychain.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to store value to.
    
    public func storeToUnencryptedKeychain(value: String, for key: String) {
        try! securePersistor.set(value, for: key, with: nil)
    }
    
    /// Restore value from unencrypted keychain.
    ///
    /// - Parameter key: The key to restore from.
    /// - Returns: Returns value in case of successful restoration, otherwise returns nil.
    
    public func restoreValueFormUnencryptedKeychain(from key: String) -> String? {
        securePersistor[key]
    }
    
    /// Restore value from password encrypred keychain with specified password.
    ///
    /// - Parameters:
    ///   - key: The key to restore from.
    ///   - password: The password to decrypt keychain item.
    /// - Returns: If value restoration was succefull returns restored value, otherwise returns nil.
    
    public func restorePasswordProtectedValue(for key: String, with password: String) -> String? {
        let context = LAContext()
        context.setCredential(password.data(using: String.Encoding.utf8), type: .applicationPassword)
        return try? securePersistor.get(key, with: context, for: nil)
    }

    /// Restore value from biometric encrypted keychain with specified localAuthentication context (LAContext after successful calling evaluatePolicy method can be passed here).
    ///
    /// - Parameters:
    ///   - key: The key to restore from.
    ///   - localAuthenticationContext: LAContext to decrypt keychain item.
    /// - Returns: If value restoration was succefull returns restored value, otherwise returns nil.
    
    public func restoreBiometricProtectedValue(for key: String, localAuthenticationContext: LAContext) -> String? {
        try? securePersistor.get(key, with: localAuthenticationContext, for: nil)
    }
    
    /// Restore value from encrypted keychain without passing specified password or local authentication context. If value is encrypted native alert for specifing decrypting value will appear.
    ///
    /// - Parameters:
    ///   - key: The key to restore from.
    ///   - reason (optional): The reason to authentificate in native alert (only for read biometric encrypted values).
    ///   - onCompletion: Callback that will be called after decryption ends. Callback will be called from DispatchQueue.global so be sure that you will handle result in correct way.
    
    public func restoreFromEncryptedKeychain(for key: String, reason: String? = nil, onCompletion: @escaping ((String?) -> Void) ) {
        DispatchQueue.global().async { [weak self] in
            do {
                let value = try self?.securePersistor.get(key, with: nil, for: reason)
                onCompletion(value)
            } catch {
                onCompletion(nil)
            }
            return
        }
    }
    
    /// Service function to check is keychain encrypted.
    ///
    /// - Parameter key: The keychain item with password encrypted value.
    /// - Returns: Returns true if keychain is encrypted, otherwise - false.
    ///            Note: for simulator always returns true.
    
    public func isKeychainEncrypted(for key: String) -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        let randomPassword = UUID().uuidString
        return restorePasswordProtectedValue(for: key, with: randomPassword) == nil
#endif
    }
    
    /// Service function to check password correctness.
    ///
    /// - Parameters:
    ///   - password: The password to check.
    ///   - key: The key for kecyhain item that is encrypted with password.
    /// - Returns: Returns true if password is correct, otherwise - returns false.
    
    public func isPasswordCorrect(_ password: String, for key: String) -> Bool {
        return restorePasswordProtectedValue(for: key, with: password) != nil
    }
    
    /// Remove keychain item from keychain.
    ///
    /// - Parameter key: The key value for keychain item.
    
    public func clearKey(_ key: String) {
        securePersistor[key] = nil
    }
    
    /// Remove all items from keychain.
    
    public func clearAllKeys() {
        securePersistor.clear()
    }
}
