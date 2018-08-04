//
//  SettingsMenuViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 7/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class SettingsMenuViewController: UITableViewController {
    let options = [("Find Contractors", "Set your personal contractors.", "findContractorSegue"),
                    ("Edit Home", "Change address, bedrooms, square footage, etc.", "editHomeSegue"),
                    ("Contact Us.", "Ask for help or tell us what you would like added.", "helpSegue"),
                    ("Sign Out.", "Log out of this account.", nil)
                  ]
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
        var TODO_AddRows:AnyObject? //Edit Profile, Reset Password
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row].0
        cell.detailTextLabel?.text = options[indexPath.row].1
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let segue = options[indexPath.row].2 else {
            print("Signing out")
            FirebaseAuthentication.sharedInstance.signOut(self)
            return
        }
        performSegue(withIdentifier: segue, sender: self)
    }
}
