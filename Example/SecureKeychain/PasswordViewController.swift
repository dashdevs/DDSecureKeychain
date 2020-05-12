//
//  PasswordViewController.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import UIKit
import SecureKeychain

class PasswordViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordForLoginTextField: UITextField!
    @IBOutlet weak var allLoginsTextView: UITextView!
    
    var keychain: KeychainItem = KeychainItemGenericPassword(service: Bundle.main.bundleIdentifier!)
    
    @IBAction func save() {
        keychain[loginTextField.text!] = passwordTextField.text
    }
    
    @IBAction func restore() {
        passwordForLoginTextField.text = keychain[loginTextField.text!]
    }
    
    @IBAction func removePasswordForLogin() {
        keychain[loginTextField.text!] = nil
    }
    
    @IBAction func restoreAllLogins() {
        allLoginsTextView.text = nil
        keychain.allKeys.forEach {
            allLoginsTextView.text = allLoginsTextView.text + "\"\($0)\"\n"
        }
    }
    
    @IBAction func removeAll() {
        keychain.clear()
    }
}
