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
    private var textFields: [UITextField] = [UITextField](repeating:UITextField(), count: 6)
    var customerData: TempCustomerData?
    var contractorData: TempContractorData?
    var userType: String?
    var originalEmail:String?
    var newEmail:String?
    var password:String?
    var selectedTitle:String?
    var firstName:String?
    var lastName:String?
    var maritalStatus:String?
    var contractorType:String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authentication.checkLogin(self) {
            print("Is Logged in at EditProfile")
            if userType == "customer" {
                print("Customer!")
                customerData = TempCustomerData(self)
            } else if userType == "contractor" {
                print("Contractor!")
                contractorData = TempContractorData(self)
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
            }
        }
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
        KeyboardUtilities.addKeyboardDismissal(self.view)
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
        if let contractorData = contractorData {
            contractorData.removeListeners()
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
            textFields[0] = cell.emailTextField
            cell.tag = 0
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordConfirmationCell", for: indexPath) as! ConfirmPasswordCell
            cell.viewController = self
            textFields[1] = cell.confirmPasswordTextField
            cell.tag = 1
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            if selectedTitle == nil {
                if userType == "customer" && customerData?.getTitle() != nil {
                    selectedTitle = customerData!.getTitle()
                } else if userType == "contractor" && contractorData?.getTitle() != nil {
                    selectedTitle = contractorData!.getTitle()
                }
            }
            if selectedTitle != nil {
                cell.textLabel?.text = selectedTitle
            }
            cell.tag = 2
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstNameCell", for: indexPath) as! FirstNameCell
            cell.viewController = self
            if firstName == nil {
                if userType == "customer" && customerData?.getFirstName() != nil {
                    firstName = customerData!.getFirstName()
                } else if userType == "contractor" && contractorData?.getFirstName() != nil {
                    firstName = contractorData!.getFirstName()
                }
            }
            cell.firstName = firstName
            cell.tag = 3
            textFields[3] = cell.firstNameTextField
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastNameCell", for: indexPath) as! LastNameCell
            cell.viewController = self
            if lastName == nil {
                if userType == "customer" && customerData?.getLastName() != nil {
                    lastName = customerData!.getLastName()
                } else if userType == "contractor" && contractorData?.getLastName() != nil {
                    lastName = contractorData!.getLastName()
                }
            }
            cell.lastName = lastName
            cell.tag = 4
            textFields[4] = cell.lastNameTextField
            return cell
        } else if indexPath.row == 5 {
            if userType == "customer" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "maritalStatusCell", for: indexPath)
                if maritalStatus == nil && customerData?.getMaritalStatus() != nil {
                    maritalStatus = customerData!.getMaritalStatus()
                }
                if !StringUtilities.isNilOrEmpty(maritalStatus) {
                    cell.textLabel?.text = maritalStatus
                } else {
                    cell.textLabel?.text = "Marital Status"
                }
                return cell
            } else if userType == "contractor" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "contractorTypeCell", for: indexPath)
                if contractorType == nil && contractorData?.getContractorType() != nil {
                    contractorType = contractorData!.getContractorType()
                }
                if contractorType != nil {
                    cell.textLabel?.text = contractorType
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            showTitleActionSheet()
        } else if indexPath.row == 5 {
            if userType == "customer" {
                showMaritalStatusActionSheet()
            } else {
                showContractorTypeActionSheet()
            }
        }
    }
    
    //Mark:- Action Handlers
    func showTitleActionSheet() {
        AlertControllerUtilities.showActionSheet(withTitle: "Which title do you prefer?", andMessage: nil, withOptions: [
            UIAlertAction(title: "Mr.", style: .default, handler: titleSelectionHandler),
            UIAlertAction(title: "Mrs.", style: .default, handler: titleSelectionHandler),
            UIAlertAction(title: "Ms.", style: .default, handler: titleSelectionHandler),
            UIAlertAction(title: "Dr.", style: .default, handler: titleSelectionHandler),
            UIAlertAction(title: "Rev.", style: .default, handler: titleSelectionHandler),
            UIAlertAction(title: "Cancel", style: .cancel, handler: titleSelectionHandler)
            ],
                                                 in: self)
    }
    func showMaritalStatusActionSheet() {
        AlertControllerUtilities.showActionSheet(withTitle: "Current Marital Status", andMessage: nil, withOptions: [
            UIAlertAction(title: "Single", style: .default, handler: maritalStatusSelectionHandler),
            UIAlertAction(title: "Married", style: .default, handler: maritalStatusSelectionHandler),
            UIAlertAction(title: "Prefer not to say", style: .default, handler: maritalStatusSelectionHandler),
            UIAlertAction(title: "Cancel", style: .cancel, handler: maritalStatusSelectionHandler)
            ],
                                                 in: self)
    }
    func showContractorTypeActionSheet() {
        AlertControllerUtilities.showActionSheet(withTitle: "Select Contractor Type", andMessage: nil, withOptions: [
            UIAlertAction(title: "Plumber", style: .default, handler: contractorTypeSelectionHandler),
            UIAlertAction(title: "Hvac", style: .default, handler: contractorTypeSelectionHandler),
            UIAlertAction(title: "Electrician", style: .default, handler: contractorTypeSelectionHandler),
            UIAlertAction(title: "Painter", style: .default, handler: contractorTypeSelectionHandler),
            UIAlertAction(title: "Cancel", style: .cancel, handler: contractorTypeSelectionHandler)
            ],
                                                 in: self)
    }
    func titleSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            if title != "Cancel" {
                selectedTitle = title
                self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            }
        }
        changeTextField(from: 2)
    }
    func maritalStatusSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            if title == "Prefer not to say" {
                maritalStatus = ""
                self.tableView.reloadData()
            } else if title != "Cancel" {
                maritalStatus = title
                self.tableView.reloadData()
            }
        }
        changeTextField(from: 6)
    }
    func contractorTypeSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            if title != "Cancel" {
                contractorType = title
                self.tableView.reloadData()
            }
        }
        changeTextField(from: 6)
    }
    func changeTextField(from previousRow: Int) {
        if previousRow == 0 {
            textFields[previousRow + 1].becomeFirstResponder()
        } else if previousRow == 1 {
            showTitleActionSheet()
        } else if previousRow < 4 {
            textFields[previousRow + 1].becomeFirstResponder()
        } else if previousRow == 4 {
            textFields[previousRow].resignFirstResponder()
            if userType == "customer" {
                showMaritalStatusActionSheet()
            } else {
                showContractorTypeActionSheet()
            }
        } else {
            resignFirstResponder()
        }
    }
    @IBAction func onConfirmAction(_ sender: UIBarButtonItem) {
        print("EditProfileViewController:- Save Changes")
        self.view.endEditing(true)
        let email = originalEmail != nil ? originalEmail!:""
        let password = self.password != nil ? self.password!:""
        let credential = authentication.getAuthCredential(withEmail: email, andPassword: password)
        authentication.getCurrentUser()?.reauthenticate(with: credential) { (result, error) in
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
                if self.userType == "customer" {
                    self.customerData?.updateName(title: selectedTitle, with: firstName, and: lastName)
                    self.customerData?.updateMaritalStatus(to: self.maritalStatus)
                } else if self.userType == "contractor" {
                    let contractorType = self.contractorType != nil ? self.contractorType!:"plumber"
                    self.contractorData?.update(title: selectedTitle, with: firstName, and: lastName, type: contractorType)
                } else {
                    AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
                }
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    //Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Data")
    }
    
    public func onSuccess() {
        print("EditProfileViewController:- Got Customer or Contractor Data")
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
        viewController?.changeTextField(from: tag)
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
        viewController?.changeTextField(from: tag)
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
        viewController?.changeTextField(from: tag)
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
        viewController?.changeTextField(from: tag)
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        viewController!.lastName = textField.text!
    }
}
