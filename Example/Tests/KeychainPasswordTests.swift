//
//  KeychainPasswordTests.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import XCTest
@testable import SecureKeychain

class KeychainPasswordTests: XCTestCase {
    private struct Constants {
        static let service = "keychain.tests"
        static let server = "http://keychain.tests.com"
        static let key = "TestKey"
        static let password = "TestPassword"
    }
    
    private var genericPasswordKeychain: KeychainItem!
    private var internetPasswordKeychain: KeychainItem!
    
    override func setUp() {
        super.setUp()
        genericPasswordKeychain = KeychainItemGenericPassword(service: Constants.service)
        internetPasswordKeychain = KeychainItemInternetPassword(server: Constants.server)
    }
    
    override func tearDown() {
        super.tearDown()
        genericPasswordKeychain.clear()
        internetPasswordKeychain.clear()
    }
    
    func testSave() {
        genericPasswordKeychain[Constants.key] = Constants.password
        internetPasswordKeychain[Constants.key] = Constants.password
        
        XCTAssertEqual(genericPasswordKeychain[Constants.key], Constants.password)
        XCTAssertEqual(internetPasswordKeychain[Constants.key], Constants.password)
    }
    
    func testRemoveOnePassword() {
        genericPasswordKeychain[Constants.key] = Constants.password
        internetPasswordKeychain[Constants.key] = Constants.password
        
        genericPasswordKeychain[Constants.key] = nil
        internetPasswordKeychain[Constants.key] = nil
        
        XCTAssertNil(genericPasswordKeychain[Constants.key])
        XCTAssertNil(internetPasswordKeychain[Constants.key])
    }
    
    func testAllKeys() {
        let items: [(key: String, password: String)] = (1...10).map { ("\(Constants.key)\($0)", Constants.password) }
        
        items.forEach {
            genericPasswordKeychain[$0.key] = $0.password
            internetPasswordKeychain[$0.key] = $0.password
        }
        
        XCTAssertEqual(genericPasswordKeychain.allKeys.count, 10)
        XCTAssertEqual(internetPasswordKeychain.allKeys.count, 10)
        
        XCTAssertEqual(genericPasswordKeychain.allKeys, items.map { $0.key })
        XCTAssertEqual(internetPasswordKeychain.allKeys, items.map { $0.key })
    }
    
    func testClear() {
        let items: [(key: String, password: String)] = (1...10).map { ("\(Constants.key)\($0)", Constants.password) }
        
        items.forEach {
            genericPasswordKeychain[$0.key] = $0.password
            internetPasswordKeychain[$0.key] = $0.password
        }
        
        genericPasswordKeychain.clear()
        internetPasswordKeychain.clear()
        
        XCTAssertEqual(genericPasswordKeychain.allKeys.count, 0)
        XCTAssertEqual(internetPasswordKeychain.allKeys.count, 0)
    }
}
