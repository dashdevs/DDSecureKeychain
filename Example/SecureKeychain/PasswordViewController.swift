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
        let accessoryView = UIToolbar()
        accessoryView.frame.size.height = 44
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
    
    @objc func cancelAccessibility() {
        view.endEditing(true)
    }
    
    @objc func setAccessibility() {
        view.endEditing(true)
        guard let accessibility = KeychainAccessibilityViewModel(rawValue: accessibilityInputView.selectedRow(inComponent: 0)) else { return }
        keychain.append(accessibility.accessibilityValue)
        accessibilityTextField.text = accessibility.title
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
