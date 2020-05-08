//
//  KeychainItemError.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

public enum KeychainItemError: Error {
    case alreadyExist
    case canNotCreateDataFromPassword
    case error(status: OSStatus)
    case notFound
    case unexpectedData
}
