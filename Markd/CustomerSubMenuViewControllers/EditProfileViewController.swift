//
//  EditProfileViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 8/4/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    var customerData: TempCustomerData?
    var originalEmail:String?
    var newEmail:String?
    var password:String?
    var selectedTitle:String?
    var firstName:String?
    var lastName:String?
    var maritalStatus:String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authentication.checkLogin(self) {
            print("Is Logged in at EditProfile")
            customerData = TempCustomerData(self)
        }
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! EmailCell
            originalEmail = authentication.getCurrentUser()?.email
            if newEmail == nil {
                newEmail = originalEmail
            }
            cell.viewController = self
            cell.email = newEmail
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordConfirmationCell", for: indexPath) as! ConfirmPasswordCell
            cell.viewController = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            if selectedTitle == nil && customerData?.getTitle() != nil {
                selectedTitle = customerData!.getTitle()
            }
            if selectedTitle != nil {
                cell.textLabel?.text = selectedTitle
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstNameCell", for: indexPath) as! FirstNameCell
            cell.viewController = self
            if firstName == nil && customerData?.getFirstName() != nil {
                firstName = customerData!.getFirstName()
            }
            cell.firstName = firstName
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastNameCell", for: indexPath) as! LastNameCell
            cell.viewController = self
            if lastName == nil && customerData?.getLastName() != nil {
                lastName = customerData!.getLastName()
            }
            cell.lastName = lastName
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "maritalStatusCell", for: indexPath)
            if maritalStatus == nil && customerData?.getMaritalStatus() != nil {
                maritalStatus = customerData!.getMaritalStatus()
            }
            if maritalStatus != nil {
                cell.textLabel?.text = maritalStatus
            }
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            AlertControllerUtilities.showActionSheet(withTitle: "Which title do you prefer?", andMessage: nil, withOptions: [
                    UIAlertAction(title: "Mr.", style: .default, handler: titleSelectionHandler),
                    UIAlertAction(title: "Mrs.", style: .default, handler: titleSelectionHandler),
                    UIAlertAction(title: "Ms.", style: .default, handler: titleSelectionHandler),
                    UIAlertAction(title: "Dr.", style: .default, handler: titleSelectionHandler),
                    UIAlertAction(title: "Rev.", style: .default, handler: titleSelectionHandler),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ],
               in: self)
        } else if indexPath.row == 5 {
            AlertControllerUtilities.showActionSheet(withTitle: "Current Marital Status", andMessage: nil, withOptions: [
                UIAlertAction(title: "Single", style: .default, handler: maritalStatusSelectionHandler),
                UIAlertAction(title: "Married", style: .default, handler: maritalStatusSelectionHandler),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ],
                 in: self)
        }
    }
    
    //Mark:- Action Handlers
    func titleSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            selectedTitle = title
            self.tableView.reloadData()
        }
    }
    func maritalStatusSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            maritalStatus = title
            self.tableView.reloadData()
        }
    }
    @IBAction func onConfirmAction(_ sender: UIBarButtonItem) {
        print("EditProfileViewController:- Save Changes")
        self.view.endEditing(true)
        let email = originalEmail != nil ? originalEmail!:""
        let password = self.password != nil ? self.password!:""
        let credential = authentication.getAuthCredential(withEmail: email, andPassword: password)
        authentication.getCurrentUser()?.reauthenticate(with: credential, completion: { (error) in
            if let error = error {
                self.authentication.errorHandler(self, forError: error)
            } else {
                print("Using correct password")
                if let newEmail = self.newEmail {
                    self.authentication.getCurrentUser()?.updateEmail(to: newEmail) { (error) in
                        if let error = error {
                            self.authentication.errorHandler(self, forError: error)
                        }
                    }
                }
                let selectedTitle = self.selectedTitle != nil ? self.selectedTitle!:"Mr."
                let firstName = self.firstName != nil ? self.firstName!:""
                let lastName = self.lastName != nil ? self.lastName!:""
                self.customerData?.updateName(title: selectedTitle, with: firstName, and: lastName)
                let maritalStatus = self.maritalStatus != nil ? self.maritalStatus!:"Single"
                self.customerData?.updateMaritalStatus(to: maritalStatus)
                self.navigationController!.popViewController(animated: true)
            }
        })
    }
    
    //Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Data")
    }
    
    public func onSuccess() {
        print("EditProfileViewController:- Got Customer Data")
        tableView.reloadData()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}

class EmailCell:UITableViewCell, UITextFieldDelegate {
    var viewController: EditProfileViewController?
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    var email:String? {
        didSet {
            emailTextField.text = email
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        viewController!.newEmail = textField.text
    }
}
class ConfirmPasswordCell:UITableViewCell, UITextFieldDelegate {
    var viewController: EditProfileViewController?
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet {
            confirmPasswordTextField.delegate = self
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        viewController!.password = textField.text
    }
}
class FirstNameCell:UITableViewCell, UITextFieldDelegate {
    var viewController: EditProfileViewController?
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet {
            firstNameTextField.delegate = self
        }
    }
    var firstName:String? {
        didSet {
            firstNameTextField.text = firstName
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        viewController!.firstName = textField.text!
    }
}
class LastNameCell:UITableViewCell, UITextFieldDelegate {
    var viewController: EditProfileViewController?
    @IBOutlet weak var lastNameTextField: UITextField! {
        didSet {
            lastNameTextField.delegate = self
        }
    }
    var lastName:String? {
        didSet {
            lastNameTextField.text = lastName
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        viewController!.lastName = textField.text!
    }
}
