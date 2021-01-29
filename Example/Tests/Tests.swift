import XCTest
import SecureKeychain
import LocalAuthentication

class Tests: XCTestCase {
    private struct Constants {
        static let passwordEncryptedKey = "PasswordEncryptedKey"
        static let unencryptedKey = "UnencryptedKey"
        static let biometricEncryptedKey = "BiometricEncryptedKey"
        static let biometricEvaluatePolicyReason = "Read biometric protected value"
        static let timeoutWaitInterval: TimeInterval = 300
        static let errorStorePasswordEncryptedValue = "Error while storing to password encrypted keychain item."
        static let errorStoreBiometricEncryptedValue = "Error while storing to biometric encrypted keychain item."
        static let errorRestoreBiometricEncryptedValye = "Error restoring biometric encrypted keychain item."
    }
    
    private var secureKeychain: SecureKeychain!
    
    override func setUp() {
        super.setUp()
        secureKeychain = SecureKeychain(keychain: KeychainItemGenericPassword(service: Bundle.main.bundleIdentifier!), accessibility: .whenUnlocked, authenticationPolicy: .biometryAny)
    }
    
    override func tearDown() {
        super.tearDown()
        secureKeychain.clearAllKeys()
    }
    
    func testStoreAndReadPasswordEncryptedValue() {
        let password = UUID().uuidString
        let valueToStore = UUID().uuidString
       
        do {
            try secureKeychain.storeToPasswordProtectedKeychain(value: valueToStore, for: Constants.passwordEncryptedKey, with: password)
        } catch {
            XCTAssert(false, Constants.errorStorePasswordEncryptedValue)
            return
        }
        
        guard let restoredValue = secureKeychain.restorePasswordProtectedValue(for: Constants.passwordEncryptedKey, with: password) else {
            XCTAssert(false, "Error restoring password encrypted keychain item.")
            return
        }
        
        guard restoredValue == valueToStore else {
            XCTAssert(false, "Restored value doesn't match with stored value for password encrypted keychain item.")
            return
        }
        XCTAssert(true, "Storing and restoring password encrypted value was successful.")
    }
    
    func testStoreAndReadUnencryptedValue() {
        let valueToStore = UUID().uuidString
        
        secureKeychain.storeToUnencryptedKeychain(value: valueToStore, for: Constants.unencryptedKey)
        guard let restoredValue = secureKeychain.restoreValueFormUnencryptedKeychain(from: Constants.unencryptedKey) else {
            XCTAssert(false, "Error restoring unencrypted keychain item.")
            return
        }
        
        guard restoredValue == valueToStore else {
            XCTAssert(false, "Restored values doesn't match with stored value for unencrypted keychain item.")
            return
        }
        XCTAssert(true, "Storing and restoring unencrypted value was successful.")
    }
    
    func testClearEncryptedValue() {
        let password = UUID().uuidString
        let valueToStore = UUID().uuidString
        
        do {
            try secureKeychain.storeToPasswordProtectedKeychain(value: valueToStore, for: Constants.passwordEncryptedKey, with: password)
        } catch {
            XCTAssert(false, Constants.errorStorePasswordEncryptedValue)
            return
        }
        
        secureKeychain.clearKey(Constants.passwordEncryptedKey)
        
        guard secureKeychain.restorePasswordProtectedValue(for: Constants.passwordEncryptedKey, with: password) == nil else {
            XCTAssert(false, "Clear encrypted keychain item failed.")
            return
        }
        
         XCTAssert(true, "Clearing encrypted keychain item was successful.")
    }
    
    func testClearAllValues() {
        let password = UUID().uuidString
        let valueToStore = UUID().uuidString
        
        do {
            try secureKeychain.storeToPasswordProtectedKeychain(value: valueToStore, for: Constants.passwordEncryptedKey, with: password)
        } catch {
            XCTAssert(false, Constants.errorStorePasswordEncryptedValue)
            return
        }
        secureKeychain.storeToUnencryptedKeychain(value: valueToStore, for: Constants.unencryptedKey)
        
        secureKeychain.clearAllKeys()
        
        guard secureKeychain.restorePasswordProtectedValue(for: Constants.passwordEncryptedKey, with: password) == nil,
            secureKeychain.restoreValueFormUnencryptedKeychain(from: Constants.unencryptedKey) == nil else {
                XCTAssert(false, "Clear all keychain item failed.")
                return
        }
        
        XCTAssert(true, "Clearing all keychain items was successful.")
    }
    
    func testIsKeychainEncrypted() {
        let password = UUID().uuidString
        let valueToStore = UUID().uuidString
        
        do {
            try secureKeychain.storeToPasswordProtectedKeychain(value: valueToStore, for: Constants.passwordEncryptedKey, with: password)
        } catch {
            XCTAssert(false, Constants.errorStorePasswordEncryptedValue)
            return
        }
        
        guard secureKeychain.isKeychainEncrypted(for: Constants.passwordEncryptedKey) else {
            XCTAssert(false, "Error while checking is keychain encrypted.")
            return
        }
        
        XCTAssert(true, "Checking is keychain encrypted was succesful.")
    }
    
    func testIsPasswordCorrect() {
        let password = UUID().uuidString
        let valueToStore = UUID().uuidString
        
        do {
            try secureKeychain.storeToPasswordProtectedKeychain(value: valueToStore, for: Constants.passwordEncryptedKey, with: password)
        } catch {
            XCTAssert(false, Constants.errorStorePasswordEncryptedValue)
            return
        }
        
        guard secureKeychain.isPasswordCorrect(password, for: Constants.passwordEncryptedKey) else {
            XCTAssert(false, "Error checking password correctness.")
            return
        }
        XCTAssert(true, "Checking password correctness was successful.")
    }
    
#if !targetEnvironment(simulator)
    func testIsPasswordIncorrect() {
        let password = UUID().uuidString
        let valueToStore = UUID().uuidString
        
        do {
            try secureKeychain.storeToPasswordProtectedKeychain(value: valueToStore, for: Constants.passwordEncryptedKey, with: password)
        } catch {
            XCTAssert(false, Constants.errorStorePasswordEncryptedValue)
            return
        }
        
        guard secureKeychain.isPasswordCorrect(password + "1", for: Constants.passwordEncryptedKey) == false else {
            XCTAssert(false, "Error checking password incorrectness.")
            return
        }
        XCTAssert(true, "Checking password incorrectness was successful.")
    }
    
    func testIsKeychainUnencrypted() {
        let valueToStore = UUID().uuidString
        secureKeychain.storeToUnencryptedKeychain(value: valueToStore, for: Constants.unencryptedKey)
        
        guard secureKeychain.isKeychainEncrypted(for: Constants.unencryptedKey) == false else {
            XCTAssert(false, "Error while checking is keychain unencrypted.")
            return
        }
        
        XCTAssert(true, "Checking is keychain unencrypted was succesful.")
    }
#endif
    
    func testStoreAndReadBiometricEncryptedValue() {
#if targetEnvironment(simulator)
        class LAContextSimulator: LAContext {
            override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) { reply(true, nil) }
            override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool { return true }
        }
        let context = LAContextSimulator()
#else
        let context = LAContext()
#endif
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            XCTAssert(false, "Can't evalute policy. Please check settings at your iPhone.")
            return
        }
        
        let valueToStore = UUID().uuidString
        
        do {
            try secureKeychain.storeToBiometricProtectedKeychain(value: valueToStore, for: Constants.biometricEncryptedKey)
        } catch {
            XCTAssert(false, Constants.errorStoreBiometricEncryptedValue)
            return
        }
        
        let expectation = XCTestExpectation(description: "biometric_read")

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: Constants.biometricEvaluatePolicyReason) { [weak self, context] (success, error) in
                if success {
                    guard let restoredValue = self?.secureKeychain.restoreBiometricProtectedValue(for: Constants.biometricEncryptedKey, localAuthenticationContext: context) else {
                            XCTAssert(false, Constants.errorRestoreBiometricEncryptedValye)
                            expectation.fulfill()
                            return
                        }
                    guard restoredValue == valueToStore else {
                        XCTAssert(false, "Restored value doesn't match with stored value for biometric encrypted keychain item.")
                        expectation.fulfill()
                        return
                    }
                    expectation.fulfill()
                    XCTAssert(true, "Storing and restoring biometric encrypted value was successful.")
                } else {
                    expectation.fulfill()
                    XCTAssert(false, "Biometric authentification was failed.")
                }
        }
        wait(for: [expectation], timeout: Constants.timeoutWaitInterval)
    }
    
    func testStoreAndReadBiometricValueWithoutContext() {
        let valueToStoreWithBiometric = UUID().uuidString
        
        do {
            try secureKeychain.storeToBiometricProtectedKeychain(value: valueToStoreWithBiometric, for: Constants.biometricEncryptedKey)
        } catch {
            XCTAssert(false, Constants.errorStoreBiometricEncryptedValue)
            return
        }
        
        let expectation = XCTestExpectation(description: "password_read")
        secureKeychain.restoreFromEncryptedKeychain(for: Constants.biometricEncryptedKey, reason: "Authentificate for read biometry protected value") { (result) in
            guard let restoredValue = result else {
                XCTAssert(false, Constants.errorRestoreBiometricEncryptedValye)
                expectation.fulfill()
                return
            }
            
            guard valueToStoreWithBiometric == restoredValue else {
                XCTAssert(false, "Restored value doesn't match with stored value for biometric encrypted keychain item.")
                expectation.fulfill()
                return
            }
            
            XCTAssert(true, "Restoring biometric encrypted values was succesful.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: Constants.timeoutWaitInterval)
    }
}
