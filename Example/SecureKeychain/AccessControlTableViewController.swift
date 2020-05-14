//
//  AccessControlTableViewController.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import UIKit
import SecureKeychain

class AccessControlTableViewController: UITableViewController {
    let accessControl: [KeychainItemAccessControl]?
    
    init?(coder: NSCoder, accessControl: [KeychainItemAccessControl]?) {
        self.accessControl = accessControl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
