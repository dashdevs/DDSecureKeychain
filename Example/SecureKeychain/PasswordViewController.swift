//
//  PasswordViewController.swift
//
//  Copyright © 2019 dashdevs.com. All rights reserved.
//

import UIKit
import SecureKeychain

class PasswordViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordForLoginTextField: UITextField!
    
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
}
