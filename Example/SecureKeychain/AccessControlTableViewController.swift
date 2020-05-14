//
//  AccessControlTableViewController.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import UIKit
import SecureKeychain

class AccessControlTableViewController: UITableViewController {
    var onSave: (([KeychainAccessControlViewModel]?) -> Void)?
    
    var accessControl: [KeychainAccessControlViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessControl?.forEach { viewModel in
            let indexPath = IndexPath(row: viewModel.rawValue, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    @IBAction func save() {
        let accessControl = tableView.indexPathsForSelectedRows?.compactMap { KeychainAccessControlViewModel(rawValue: $0.row) }
        onSave?(accessControl)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
