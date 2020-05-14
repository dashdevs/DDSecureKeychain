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
    
    lazy var accessibilityInputView: UIPickerView = {
        let inputView = UIPickerView()
        inputView.delegate = self
        inputView.dataSource = self
        inputView.backgroundColor = .white
        return inputView
    }()
    lazy var accessibilityInputAccessoryView: UIView = {
        let accessoryView = UIToolbar(frame: CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: 44))
        accessoryView.items = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAccessibility)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(setAccessibility))
        ]
        return accessoryView
    }()
    @IBOutlet weak var accessibilityTextField: UITextField! {
        didSet {
            accessibilityTextField.inputView = accessibilityInputView
            accessibilityTextField.inputAccessoryView = accessibilityInputAccessoryView
        }
    }
    
    var keychain: KeychainItem = KeychainItemGenericPassword(service: Bundle.main.bundleIdentifier!)
    var accessibility: KeychainItemAccessibility?
    
    @IBAction func save() {
        guard let accessibility = self.accessibility else {
            keychain[loginTextField.text!] = passwordTextField.text
            return
        }
        do {
            let accessLevel: KeychainItemAccessLevel = (accessibility, nil)
            try keychain.set(passwordTextField.text, for: loginTextField.text!, with: accessLevel)
        } catch {
            let message: String
            switch error as? KeychainItemError {
            case .alreadyExistWithOtherAccessibility: message = "Already Exist With Other Accessibility"
            default: message = error.localizedDescription
            }
            let alert = UIAlertController(title: "Keychain Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
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
    
    @objc func cancelAccessibility() {
        view.endEditing(true)
    }
    
    @objc func setAccessibility() {
        view.endEditing(true)
        guard let accessibility = KeychainAccessibilityViewModel(rawValue: accessibilityInputView.selectedRow(inComponent: 0)) else { return }
        accessibilityTextField.text = accessibility.title
        self.accessibility = accessibility.accessibilityValue
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension PasswordViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return KeychainAccessibilityViewModel.allCases.count
    }
}

extension PasswordViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return KeychainAccessibilityViewModel(rawValue: row)?.title
    }
}
