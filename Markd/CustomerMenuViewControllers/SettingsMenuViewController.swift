//
//  SettingsMenuViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 7/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase

class SettingsMenuViewController: UITableViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    var options:[(String, String, String)] = []
    let customerOptions = [("Find Contractors", "Set your personal contractors.", "findContractorSegue"),
                    ("Edit Home", "Change address, bedrooms, square footage, etc.", "editHomeSegue"),
                    ("Edit Profile", "Change email or name on account.", "editProfileSegue"),
                    ("Contact Us", "Ask for help or tell us what you would like added.", "helpSegue"),
                    ("Reset Password", "An email will be sent to change password.", "resetPasswordSegue"),
                    ("Sign Out", "Log out of this account.", "signOutSegue")]
    let contractorOptions = [("Edit Profile", "Change email or name on account.", ""),
                             ("Edit Company", "Change company telephone, phone number, etc.", "editCompanySegue"),
                             ("Contact Us", "Ask for help or tell us what you would like added.", "helpSegue"),
                             ("Reset Password", "An email will be sent to change password.", ""),
                             ("Sign Out", "Log out of this account.", "signOutSegue")]
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if authentication.checkLogin(self) {
            authentication.getUserType(in: self, listener: setUpOptions)
        } else {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        tableView.tableFooterView = UIView()
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
        return options.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row].0
        cell.detailTextLabel?.text = options[indexPath.row].1
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let segue = options[indexPath.row].2
        if segue == "signOutSegue" {
            print("Signing out")
            FirebaseAuthentication.sharedInstance.signOut(self)
        } else if segue == "resetPasswordSegue" {
            print("Send password reset email")
            FirebaseAuthentication.sharedInstance.forgotPassword(self, withEmail: FirebaseAuthentication.sharedInstance.getCurrentUser()!.email!)
        } else {
            performSegue(withIdentifier: segue, sender: self)
        }
    }
    
    // Mark:- Helper
    private func setUpOptions(snapShot: DataSnapshot) {
        print("Setting up options")
        guard let snapShotDictionary = snapShot.value as? Dictionary<String, AnyObject> else {
            print("Error")
            authentication.signOut(self)
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        let userType = snapShotDictionary["userType"] as? String
        if(userType == "customer") {
            options = customerOptions
            tableView.reloadData()
        } else if (userType == "contractor") {
            options = contractorOptions
            tableView.reloadData()
        } else {
            authentication.signOut(self)
            print(userType!)
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
    }
}
