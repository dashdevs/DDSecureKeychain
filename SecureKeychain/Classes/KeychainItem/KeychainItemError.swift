//
//  KeychainItemError.swift
//
//  Copyright © 2018 dashdevs.com. All rights reserved.
//

public enum KeychainItemError: Error {
    case canNotCreateDataFromPassword
    case error(status: OSStatus)
    case itemAlreadyExist
}
