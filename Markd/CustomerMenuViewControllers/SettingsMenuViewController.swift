//
//  SettingsMenuViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 7/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class SettingsMenuViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        tableView.tableFooterView = UIView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        ViewControllerUtilities.insertMarkdLogo(into: self)
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var TODO_AddRows:AnyObject? //Edit Profile, Edit Home, Find Contractor, Reset Password
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = "Find Contractors"
            cell.detailTextLabel?.text = "Set your personal contractors."
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = "Contact Us"
            cell.detailTextLabel?.text = "Ask for help or tell us what you would like added."
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = "Sign Out"
            cell.detailTextLabel?.text = "Log out of the current account."
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "findContractorSegue", sender: self)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "helpSegue", sender: self)
        } else if indexPath.row == 2 {
            print("Signing out")
            FirebaseAuthentication.sharedInstance.signOut(self)
        }
    }
}
