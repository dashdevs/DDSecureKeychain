//
//  KeychainItemError.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import Foundation

/// List of errors that we can get when saving and retrieving data

public enum KeychainItemError: Error, Equatable {
    case alreadyExist
    case alreadyExistWithOtherAccessibility
    case canNotCreateDataFromPassword
    case error(status: OSStatus)
    case notFound
    case unexpectedData
}
