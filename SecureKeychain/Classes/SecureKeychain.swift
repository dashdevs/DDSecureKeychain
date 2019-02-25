//
//  SecureKeychain.swift
//
//  Copyright © 2018 dashdevs.com. All rights reserved.
//

import LocalAuthentication
import KeychainAccess

public enum KeychainKeys: String {
    case testKey = "TestKey"
    case passwordKey = "PasswordProtectedKey"
    case biometricKey = "BiometricKey"
}

public class SecureKeychain {
    private var securePersistor: Keychain
    
    public init() {
        let bundleID = Bundle.main.bundleIdentifier!
        securePersistor = Keychain(service: bundleID)
    }
    
    private func passcodeEncryptedKeyChain(for passcode: String) -> Keychain {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.setCredential(passcode.data(using: String.Encoding.utf8), type: .applicationPassword)
        let keychain = securePersistor.authenticationContext(localAuthenticationContext)
        return keychain
    }
    
    private func setEncryptedValue(_ value: String, with policy: AuthenticationPolicy, for key: String, to keychain: Keychain) {
        keychain.accessibility(.whenUnlocked, authenticationPolicy: [policy])[key] = value
    }
    
    private func restoreEncryptedValue(from keychain: Keychain, for key: String) -> String? {
        do {
            guard let value = try keychain.get(key) else {
                return nil
            }
            return value
        } catch {
            return nil
        }
    }
    
    public func isKeychainEncrypted() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        let randomPassword = UUID().uuidString
        return restorePasswordProtectedValue(for: KeychainKeys.passwordKey.rawValue, with: randomPassword) == nil
#endif
    }
    
    public func storeToPasswordProtectedKeychain(value: String, for key: String, password: String) {
        try! securePersistor.remove(key)
        let keychain = passcodeEncryptedKeyChain(for: password)
        setEncryptedValue(value, with: .applicationPassword, for: key, to: keychain)
    }
    
    public func storeToBiometricProtectedKeychain(value: String, for key: String) {
        try! securePersistor.remove(key)
        let localAuthenticationContext = LAContext()
        let keychainBio = securePersistor.authenticationContext(localAuthenticationContext)
        setEncryptedValue(value, with: .touchIDAny, for: key, to: keychainBio)
    }
    
    public func storeToUsualdKeychain(value: String, for key: String) {
        try! securePersistor.set(value, key: key)
    }
    
    public func restoreUsualKeychainValue(from key: String) -> String? {
        do {
            let value = try securePersistor.get(key)
            return value
        } catch {
            return nil
        }
    }
    
    public func restorePasswordProtectedValue(for key: String, with password: String) -> String? {
        let keychain = passcodeEncryptedKeyChain(for: password)
        let result = restoreEncryptedValue(from: keychain, for: key)
        return result
    }
    
    public func restoreBiometricProtectedValue(for key: String) -> String? {
        let localAuthenticationContext = LAContext()
        let keychainBio = securePersistor.authenticationContext(localAuthenticationContext)
        let result = restoreEncryptedValue(from: keychainBio, for: key)
        return result
    }
    
    public func usualRestoreFromEncryptedKeychain(for key: String, onCompletion: @escaping ((String?) -> Void) ) {
        DispatchQueue.global().async { [unowned self] in
            do {
                let value = try self.securePersistor.get(key)
                onCompletion(value)
            } catch {
                onCompletion(nil)
            }
            return
        }
    }
    
    public func isPasswordCorrect(_ password: String) -> Bool {
        return restorePasswordProtectedValue(for: KeychainKeys.passwordKey.rawValue, with: password) != nil
    }
    
    public func clearKey(_ key: String) {
        try! securePersistor.remove(key)
    }
}
