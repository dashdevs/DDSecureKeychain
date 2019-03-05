//
//  ViewController.swift
//
//  Copyright © 2019 dashdevs.com. All rights reserved.
//

import UIKit
import SecureKeychain

public enum KeychainKeys: String {
    case testKey = "TestKey"
    case passwordKey = "PasswordProtectedKey"
    case biometricKey = "BiometricKey"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var savedValue: UITextField!
    @IBOutlet weak var applicationPassword: UITextField!
    @IBOutlet weak var usualValue: UITextField!
    @IBOutlet weak var passwordProtectedValue: UITextField!
    @IBOutlet weak var biometricProtectedValue: UITextField!
    @IBOutlet weak var usualReadValue: UITextField!
    @IBOutlet weak var isEncryptedKeychain: UITextField!
    @IBOutlet weak var isPasswordCorrect: UITextField!
    
    private lazy var secureKeychain = SecureKeychain(accessibility: .whenUnlocked, authenticationPolicy: .touchIDAny)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedValue.delegate = self
        applicationPassword.delegate = self
    }
    
    @IBAction func saveButtonTap(_ sender: Any) {
        let saveValue = (savedValue.text ?? "")
        var value = "Usual: " + saveValue
        secureKeychain.storeToUnencryptedKeychain(value: value, for: KeychainKeys.testKey.rawValue)
        
        value = "Password: " + saveValue
        do {
            try secureKeychain.storeToPasswordProtectedKeychain(value: value, for: KeychainKeys.passwordKey.rawValue, with: applicationPassword.text ?? "")
        } catch {
            showAlert(title: "Error while saving to password protected keychain", message: "Error: \(error)")
            return
        }
        
        value = "Biometric: " + saveValue
        do {
            try secureKeychain.storeToBiometricProtectedKeychain(value: value, for: KeychainKeys.biometricKey.rawValue)
        } catch {
            showAlert(title: "Error while saving to biometric protected keychain", message: "Error: \(error)")
            return
        }
        showAlert(title: "Saving successful!", message: "")
    }
    
    @IBAction func readUsusalKeychainTap(_ sender: Any) {
        usualValue.text = secureKeychain.restoreValueFormUnencryptedKeychain(from: KeychainKeys.testKey.rawValue)
    }
    
    @IBAction func readPasswordKeychainTap(_ sender: Any) {
        passwordProtectedValue.text = secureKeychain.restorePasswordProtectedValue(for: KeychainKeys.passwordKey.rawValue, with: applicationPassword.text ?? "")
    }
    
    @IBAction func readBiometricProtectedTap(_ sender: Any) {
        secureKeychain.restoreFromEncryptedKeychain(for: KeychainKeys.biometricKey.rawValue) { [unowned self] (result) in
            DispatchQueue.main.async { [unowned self] in
                self.biometricProtectedValue.text = result
            }
        }
    }
    
    @IBAction func readFromSecureKeychainTap(_ sender: Any) {
        secureKeychain.restoreFromEncryptedKeychain(for: KeychainKeys.passwordKey.rawValue) { [unowned self] (result) in
            DispatchQueue.main.async { [unowned self] in
                self.usualReadValue.text = result
            }
        }
    }
    
    @IBAction func isKeychainEncryptedTap(_ sender: Any) {
        isEncryptedKeychain.text = secureKeychain.isKeychainEncrypted(for: KeychainKeys.passwordKey.rawValue) ? "Yes" : "No"
    }
    
    @IBAction func isPasswordCorrectTap(_ sender: Any) {
        let passwordCorrect = secureKeychain.isPasswordCorrect(applicationPassword.text ?? "", for: KeychainKeys.passwordKey.rawValue)
        isPasswordCorrect.text = passwordCorrect ? "Correct" : "Not correct"
    }
    
    @IBAction func clearPasswordKeyTap(_ sender: Any) {
        secureKeychain.clearKey(KeychainKeys.passwordKey.rawValue)
    }
    
    @IBAction func clearFingerprintKeyTap(_ sender: Any) {
        secureKeychain.clearKey(KeychainKeys.biometricKey.rawValue)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == savedValue else {
            textField.resignFirstResponder()
            return true
        }
        applicationPassword.becomeFirstResponder()
        return true
    }
}

