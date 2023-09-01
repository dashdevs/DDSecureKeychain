//
//  AccessControlTableViewController.swift
//
//  Copyright © 2020 dashdevs.com. All rights reserved.
//

import UIKit

class AccessControlTableViewController: UITableViewController {
    private struct ReuseIdentifiers {
        static let cell = "BasicCell"
    }
    
    var onSave: (([KeychainAccessControlViewModel]) -> Void)?
    
    var accessControl: [KeychainAccessControlViewModel] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KeychainAccessControlViewModel.allCases.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.cell, for: indexPath)
        let viewModel = KeychainAccessControlViewModel(rawValue: indexPath.row)
        cell.textLabel?.text = viewModel?.title
        viewModel.map {
            guard accessControl.contains($0) == true else { return }
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    @IBAction func save() {
        onSave?(accessControl)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = KeychainAccessControlViewModel(rawValue: indexPath.row) else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        accessControl.append(viewModel)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let viewModel = KeychainAccessControlViewModel(rawValue: indexPath.row), let index = accessControl.index(of: viewModel) else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        accessControl.remove(at: index)
    }
}
