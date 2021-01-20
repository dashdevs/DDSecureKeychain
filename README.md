# SecureKeychain

KeychainAccess is a simple Swift wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs extremely easy and much more palatable to use in Swift.

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

#### Saving

#### Initialization Application Password

```swift
let secureKeychain = SecureKeychain(keychain: KeychainItemGenericPassword(service: "keychain.tests.com"), accessibility: .whenUnlocked, authenticationPolicy: .biometryAny)
```

#### Initialization Internet Password

```swift
let secureKeychain = SecureKeychain(keychain: KeychainItemInternetPassword(server: "https://keychain.tests.com"), accessibility: .whenUnlocked, authenticationPolicy: .biometryAny)
```

#### store using password protected

```swift
do {
    try secureKeychain.storeToPasswordProtectedKeychain(value: "Value to store in keychain", for: "PasswordProtectedKey", with: "Password")
} catch {
    print("Error while saving to password protected keychain")
    return
}
```

#### store using biometric protected

```swift
do {
    try secureKeychain.storeToBiometricProtectedKeychain(value: "Value to store in keychain", for: "BiometricKey")
} catch {
    print("Error while saving to biometric protected keychain")
    return
}
```

## Author

kirill.u@itomy.ch

## License

SecureKeychain is available under the MIT license. See the LICENSE file for more info.
