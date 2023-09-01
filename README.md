# SecureKeychain

KeychainAccess is a simple Swift wrapper for Keychain that works on iOS and OS X. It makes using Keychain APIs extremely easier and much more comfortable using in Swift.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+ / macOS 10.15+
- Xcode 11+
- Swift 5.1+

## Installation

SecureKeychain is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SecureKeychain'
```

## Usage

### Basics

#### Saving Application Password

```swift
var keychain = KeychainItemGenericPassword(service: "keychain.test")
keychain["key"] = "password"
```

#### Saving Internet Password

```swift
var keychain = KeychainItemInternetPassword(server: "https://github.com")
keychain["key"] = "3yh3dfgt-s55d-6sf3-rt33-feserte4345t"
```

#### Initialization Application Password

```swift
var keychain = KeychainItemGenericPassword(service: "keychain.test")
```
#### or

```swift
let secureKeychain = SecureKeychain(keychain: KeychainItemGenericPassword(service: "keychain.test"), accessibility: .whenUnlocked, authenticationPolicy: .biometryAny)
```

#### Initialization Internet Password

```swift
var keychain = KeychainItemInternetPassword(server: "https://github.com")
```
#### or

```swift
let secureKeychain = SecureKeychain(keychain: KeychainItemInternetPassword(server: "https://github.com"), accessibility: .whenUnlocked, authenticationPolicy: .biometryAny)
```

#### Store using password protected

```swift
do {
    try secureKeychain.storeToPasswordProtectedKeychain(value: "Value to store in keychain", for: "PasswordProtectedKey", with: "Password")
} catch {
    print("Error while saving to password protected keychain")
    return
}
```

#### Store using biometric protected

```swift
do {
    try secureKeychain.storeToBiometricProtectedKeychain(value: "Value to store in keychain", for: "BiometricKey")
} catch {
    print("Error while saving to biometric protected keychain")
    return
}
```

### Adding an item

##### for String

```swift
keychain["key"] = "3yh3dfgt-s55d-6sf3-rt33-feserte4345t"
```

#### set method with error handling

```swift
let accessibility: KeychainItemAccessibility = .whenUnlocked
let accessControl: [KeychainAccessControlViewModel] = [.biometryAny]
let accessLevel: KeychainItemAccessLevel = (accessibility, accessControl.map { $0.value }, nil)

do {
    try keychain.set("password", for: "login", with: accessLevel)
} catch {
    print(error)
}
```

### Obtaining an item

##### for String

```swift
let token = keychain["key"]
```

##### get method

```swift
let token = try? keychain.get(loginTextField.text!, with: nil, for: nil)
```

#### restore all keys

```swift
let allKeys = keychain.allKeys
```

#### restore password protected value

```swift
let password = secureKeychain.restorePasswordProtectedValue(for: "PasswordProtectedKey", with: "Password")
```

#### restore value that is protected by biometrics

```swift
secureKeychain.restoreFromEncryptedKeychain(for: "BiometricKey") { value in
    print(value)
}
```

### Removing an item

#### subscripting

```swift
keychain["key"] = nil
```

#### remove methods

```swift
keychain.clear()
```

```swift
secureKeychain.clearKey("PasswordProtectedKey")
```

```swift
secureKeychain.clearKey("BiometricKey")
```

## Author

kirill.u@itomy.ch

## License

SecureKeychain is available under the MIT license. See the LICENSE file for more info.
