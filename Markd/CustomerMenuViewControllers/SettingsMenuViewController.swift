//
//  SettingsMenuViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 7/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase

class SettingsMenuViewController: UITableViewController, PurchaseHandler, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var contractorData: TempContractorData?
    var userType:String?
    var options:[(String, String, String)] = []
    let customerOptions = [("Find Contractors", "Set your personal contractors.", "findContractorSegue"),
                    ("Edit Home", "Change address, bedrooms, square footage, etc.", "editHomeSegue"),
                    ("Edit Profile", "Change email or name on account.", "editProfileSegue"),
                    ("Contact Us", "Ask for help or tell us what you would like added.", "helpSegue"),
                    ("Reset Password", "An email will be sent to change password.", "resetPasswordSegue"),
                    ("Sign Out", "Log out of this account.", "signOutSegue")]
    let contractorOptions = [("Edit Profile", "Change email or name on account.", "editProfileSegue"),
                             ("Edit Company", "Change company website, phone number, etc.", "editCompanySegue"),
                             ("Contact Us", "Ask for help or tell us what you would like added.", "helpSegue"),
                             ("Reset Password", "An email will be sent to change password.", "resetPasswordSegue"),
                             ("Restore Purchases", "Restore app subscpriptions on other devices.", "restorePurchasesSegue"),
                             ("Sign Out", "Log out of this account.", "signOutSegue")]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        ViewControllerUtilities.insertMarkdLogo(into: self)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if authentication.checkLogin(self) {
            authentication.getUserType(in: self, listener: setUpOptions)
        } else {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let contractorData = contractorData {
            contractorData.removeListeners()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK:- Table view data source
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
            authentication.forgotPassword(self, withEmail: FirebaseAuthentication.sharedInstance.getCurrentUser()!.email!)
        } else if segue == "restorePurchasesSegue" {
            print("Restoring Purchases.")
            InAppPurchasesObserver.instance.restorePurchase(self)
        } else {
            performSegue(withIdentifier: segue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let destination = segue.destination as! EditProfileViewController
            destination.userType = self.userType
        }
    }
    
    // Mark:- Helper
    private func setUpOptions(snapShot: DataSnapshot) {
        guard let snapShotDictionary = snapShot.value as? Dictionary<String, AnyObject> else {
            authentication.signOut(self)
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        userType = snapShotDictionary["userType"] as? String
        if(userType == "customer") {
            options = customerOptions
            tableView.reloadData()
        } else if (userType == "contractor") {
            contractorData = TempContractorData(self)
            options = contractorOptions
            tableView.reloadData()
        } else {
            authentication.signOut(self)
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
    }
    
    //Mark:- OnGetDataListener Implementation
    public func onStart() {
        print("SettingsMenuViewController:- Getting Contractor Data")
    }
    
    public func onSuccess() {
        print("SettingsMenuViewController:- Got Contractor Data")
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
    
    //Mark:- PurchaseHandler Implementation
    public func purchase(_ action: UIAlertAction) {
        //Prevent message from being shown every time by setting subscription expiration to the past
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        contractorData?.setSubscriptionExpiration(to: oneDayAgo)
        if action.title == "Subscribe" {
            //The Observer will set the expiration date to the future if purchase is successful
            InAppPurchasesObserver.instance.purchase(self)
        }
    }
    
    public func purchase(wasSuccessful: Bool) {
        if wasSuccessful {
            let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: Date())
            contractorData?.setSubscriptionExpiration(to: oneYearFromNow)
        } else {
            let fourDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: Date())
            contractorData?.setSubscriptionExpiration(to: fourDaysAgo)
        }
    }
}
