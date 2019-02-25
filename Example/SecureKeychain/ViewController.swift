//
//  ViewController.swift
//
//  Copyright © 2019 dashdevs.com. All rights reserved.
//

import UIKit
import SecureKeychain

class ViewController: UIViewController {
    
    @IBOutlet weak var savedValue: UITextField!
    @IBOutlet weak var applicationPassword: UITextField!
    @IBOutlet weak var usualValue: UITextField!
    @IBOutlet weak var passwordProtectedValue: UITextField!
    @IBOutlet weak var biometricProtectedValue: UITextField!
    @IBOutlet weak var usualReadValue: UITextField!
    @IBOutlet weak var isEncryptedKeychain: UITextField!
    @IBOutlet weak var isPasswordCorrect: UITextField!
    
    private lazy var secureKeychain = SecureKeychain()
    
    @IBAction func saveButtonTap(_ sender: Any) {
        let saveValue = (savedValue.text ?? "")
        var value = "Usual: " + saveValue
        secureKeychain.storeToUsualdKeychain(value: value, for: KeychainKeys.testKey.rawValue)
        
        value = "Password: " + saveValue
        secureKeychain.storeToPasswordProtectedKeychain(value: value, for: KeychainKeys.passwordKey.rawValue, password: applicationPassword.text ?? "")
        
        value = "Biometric: " + saveValue
        secureKeychain.storeToBiometricProtectedKeychain(value: value, for: KeychainKeys.biometricKey.rawValue)
    }
    
    @IBAction func readUsusalKeychainTap(_ sender: Any) {
        usualValue.text = secureKeychain.restoreUsualKeychainValue(from: KeychainKeys.testKey.rawValue)
    }
    
    @IBAction func readPasswordKeychainTap(_ sender: Any) {
        passwordProtectedValue.text = secureKeychain.restorePasswordProtectedValue(for: KeychainKeys.passwordKey.rawValue, with: applicationPassword.text ?? "")
    }
    
    @IBAction func readBiometricProtectedTap(_ sender: Any) {
        secureKeychain.usualRestoreFromEncryptedKeychain(for: KeychainKeys.biometricKey.rawValue) { [unowned self] (result) in
            DispatchQueue.main.async { [unowned self] in
                self.biometricProtectedValue.text = result
            }
        }
    }
    
    @IBAction func readFromSecureKeychainTap(_ sender: Any) {
        secureKeychain.usualRestoreFromEncryptedKeychain(for: KeychainKeys.passwordKey.rawValue) { [unowned self] (result) in
            DispatchQueue.main.async { [unowned self] in
                self.usualReadValue.text = result
            }
        }
    }
    
    @IBAction func isKeychainEncryptedTap(_ sender: Any) {
        isEncryptedKeychain.text = secureKeychain.isKeychainEncrypted() ? "Yes" : "No"
    }
    
    @IBAction func isPasswordCorrectTap(_ sender: Any) {
        let passwordCorrect = secureKeychain.isPasswordCorrect(applicationPassword.text ?? "")
        isPasswordCorrect.text = passwordCorrect ? "Correct" : "Not correct"
    }
    
    @IBAction func clearPasswordKeyTap(_ sender: Any) {
        secureKeychain.clearKey(KeychainKeys.passwordKey.rawValue)
    }
    
    @IBAction func clearFingerprintKeyTap(_ sender: Any) {
        secureKeychain.clearKey(KeychainKeys.biometricKey.rawValue)
    }
}

