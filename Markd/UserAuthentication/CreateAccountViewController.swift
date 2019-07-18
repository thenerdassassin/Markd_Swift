//
//  CreateAccountViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 8/10/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreateAccountViewController:UITableViewController, LoginHandler, OnGetDataListener {
    var textFields = [UITextField](repeating: UITextField(), count: 6)
    var customerData:TempCustomerData?
    var contractorData: TempContractorData?
    var email:String?
    var password:String?
    var confirmedPassword:String?
    var selectedTitle:String?
    var firstName:String?
    var lastName:String?
    var maritalStatus:String?
    var isContractor:Bool = false
    var contractorType:String?
    var badField:Int? {
        willSet {
            if let row = badField, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.white
                cell.selectedBackgroundView = backgroundView
                cell.isHighlighted = false
            }
        }
        didSet {
            if let row = badField, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2)
                cell.selectedBackgroundView = backgroundView
                cell.isHighlighted = true
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Opening CrateAccountVC")
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! CreateEmailCell
            cell.viewController = self
            cell.email = email
            cell.tag = 0
            textFields[0] = cell.emailTextField
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! CreatePasswordCell
            cell.viewController = self
            cell.password = password
            cell.tag = 1
            textFields[1] = cell.passwordTextField
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordConfirmationCell", for: indexPath) as! PasswordConfirmationCell
            cell.viewController = self
            cell.password = confirmedPassword
            cell.tag = 2
            textFields[2] = cell.passwordTextField
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            if selectedTitle != nil {
                cell.textLabel?.text = selectedTitle
            } else {
                cell.textLabel?.text = "Title"
            }
            cell.tag = 3
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstNameCell", for: indexPath) as! CreateFirstNameCell
            cell.viewController = self
            cell.firstName = firstName
            cell.tag = 4
            textFields[4] = cell.firstNameTextField
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastNameCell", for: indexPath) as! CreateLastNameCell
            cell.viewController = self
            cell.lastName = lastName
            cell.tag = 5
            textFields[5] = cell.lastNameTextField
            return cell
        } else if indexPath.row == 6 {
            if isContractor {
                let cell = tableView.dequeueReusableCell(withIdentifier: "contractorTypeCell", for: indexPath)
                if contractorType != nil {
                    cell.textLabel?.text = contractorType
                } else {
                    cell.textLabel?.text = "Contractor Type"
                }
                cell.tag = 6
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "maritalStatusCell", for: indexPath)
                if maritalStatus != nil {
                    cell.textLabel?.text = maritalStatus
                } else {
                    cell.textLabel?.text = "Marital Status"
                }
                cell.tag = 6
                return cell
            }
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == badField {
            badField = nil
        }
        showActionSheet(for: indexPath.row)
    }
    //Mark:- Helper Functions
    func changeTextField(from previousCell:Int) {
        if previousCell < 2 {
            textFields[previousCell + 1].becomeFirstResponder()
        } else if previousCell == 2 {
            showActionSheet(for: previousCell+1)
        } else if previousCell < 5 {
            textFields[previousCell + 1].becomeFirstResponder()
        } else if previousCell == 5 {
            showActionSheet(for: previousCell+1)
        } else {
            self.view.endEditing(true)
        }
    }
    
    func showActionSheet(for row:Int) {
        if row == 3 {
            AlertControllerUtilities.showActionSheet(withTitle: "Which title do you prefer?", andMessage: nil, withOptions: [
                UIAlertAction(title: "Mr.", style: .default, handler: titleSelectionHandler),
                UIAlertAction(title: "Mrs.", style: .default, handler: titleSelectionHandler),
                UIAlertAction(title: "Ms.", style: .default, handler: titleSelectionHandler),
                UIAlertAction(title: "Dr.", style: .default, handler: titleSelectionHandler),
                UIAlertAction(title: "Rev.", style: .default, handler: titleSelectionHandler),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ], in: self)
        } else if row == 6 {
            if isContractor {
                AlertControllerUtilities.showActionSheet(withTitle: "What type of contractor are you?", andMessage: nil, withOptions: [
                    UIAlertAction(title: "Plumber", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Hvac", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Electrician", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Painter", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    ], in: self)
            } else {
                AlertControllerUtilities.showActionSheet(withTitle: "Current Marital Status", andMessage: nil, withOptions: [
                    UIAlertAction(title: "Single", style: .default, handler: maritalStatusSelectionHandler),
                    UIAlertAction(title: "Married", style: .default, handler: maritalStatusSelectionHandler),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    ], in: self)
            }
        }
    }
    
    //Mark:- Action Handlers
    func titleSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            selectedTitle = title
            //self.tableView.reloadData()
            self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
            changeTextField(from: 3)
        }
    }
    func maritalStatusSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            maritalStatus = title
            //self.tableView.reloadData()
            self.tableView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
            changeTextField(from: 6)
        }
    }
    func contractorTypeSelectionHandler(alert: UIAlertAction!) {
        if let title = alert.title {
            contractorType = title
            //self.tableView.reloadData()
            self.tableView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
            changeTextField(from: 6)
        }
    }
    @IBAction func onDoneAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        guard isValidInput() else {
            return
        }
        FirebaseAuthentication.sharedInstance.createUser(self, withEmail: email!, andPassword: password!)
    }
    private func isValidInput() -> Bool {
        if StringUtilities.isNilOrEmpty(email) {
            AlertControllerUtilities.showAlert(withTitle: "Email address is required.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
            badField = 0
            return false
        } else if StringUtilities.isNilOrEmpty(password) {
            AlertControllerUtilities.showAlert(withTitle: "Must enter password.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
            badField = 1
            return false
        } else if password!.count < 6 {
            AlertControllerUtilities.showAlert(withTitle: "Password must be greater than 6 characters.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
            badField = 1
            return false
        } else if password != confirmedPassword {
            AlertControllerUtilities.showAlert(withTitle: "Passwords do not match.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
            badField = 2
            return false
        } else if StringUtilities.isNilOrEmpty(selectedTitle) || selectedTitle == "Title" {
            AlertControllerUtilities.showAlert(withTitle: "Title is required.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
            badField = 3
            return false
        } else if StringUtilities.isNilOrEmpty(firstName) {
            AlertControllerUtilities.showAlert(withTitle: "First name is required.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
            badField = 4
            return false
        } else if StringUtilities.isNilOrEmpty(lastName) {
            AlertControllerUtilities.showAlert(withTitle: "Last name is required.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
            badField = 5
            return false
        } else {
            if isContractor {
                if StringUtilities.isNilOrEmpty(contractorType) || maritalStatus == "Contractor Type" {
                    AlertControllerUtilities.showAlert(withTitle: "Contractor Type is required.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
                    badField = 6
                    return false
                }
            } else {
                if StringUtilities.isNilOrEmpty(maritalStatus) || maritalStatus == "Marital Status" {
                    AlertControllerUtilities.showAlert(withTitle: "Marital Status is required.", andMessage: nil, withOptions: [UIAlertAction(title: "Try again", style: .default, handler: nil)], in: self)
                    badField = 6
                    return false
                }
            }
        }
        return true
    }
    
    //Mark:- LoginHandler
    func loginSuccessHandler(_ user: User) {
        if isContractor {
            var data:Dictionary<String, AnyObject> = [:]
            let namePrefix = selectedTitle as AnyObject
            let firstName = self.firstName as AnyObject
            let lastName = self.lastName as AnyObject
            let contractorType = self.contractorType as AnyObject
            data = ["namePrefix":namePrefix, "firstName":firstName, "lastName":lastName, "type":contractorType]
            let contractor = Contractor(data)
            contractorData = TempContractorData(self, create: contractor, at: user.uid)
        } else {
            var data:Dictionary<String, AnyObject> = [:]
            let namePrefix = selectedTitle as AnyObject
            let firstName = self.firstName as AnyObject
            let lastName = self.lastName as AnyObject
            let maritalStatus = self.maritalStatus as AnyObject
            data = ["namePrefix":namePrefix, "firstName":firstName, "lastName":lastName, "maritalStatus":maritalStatus]
            let customer = Customer(data)
            customerData = TempCustomerData(self, create: customer, at: user.uid)
        }
        print("Created Account")
    }
    
    func loginFailureHandler(_ error: Error) {
        FirebaseAuthentication.sharedInstance.errorHandler(self, forError: error)
    }
    
    //Mark:- OnGetDataListener
    func onStart() {
        print("Getting customer data")
    }
    
    func onSuccess() {
        print("CreateAccountViewController:- Got Customer")
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func onFailure(_ error: Error) {
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}

class CreateEmailCell:UITableViewCell, UITextFieldDelegate {
    var viewController: CreateAccountViewController?
    
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
        //textField.resignFirstResponder()
        viewController?.changeTextField(from: self.tag)
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isHighlighted = false
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        viewController!.email = textField.text
    }
}
class CreatePasswordCell:UITableViewCell, UITextFieldDelegate {
    var viewController: CreateAccountViewController?
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    var password:String? {
        didSet {
            passwordTextField.text = password
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewController?.changeTextField(from: self.tag)
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isHighlighted = false
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        viewController!.password = textField.text
    }
}
class PasswordConfirmationCell:UITableViewCell, UITextFieldDelegate {
    var viewController: CreateAccountViewController?
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    var password:String? {
        didSet {
            passwordTextField.text = password
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewController?.changeTextField(from: self.tag)
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isHighlighted = false
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        viewController!.confirmedPassword = textField.text
    }
}
class CreateFirstNameCell:UITableViewCell, UITextFieldDelegate {
    var viewController: CreateAccountViewController?
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
        viewController?.changeTextField(from: self.tag)
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isHighlighted = false
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        viewController!.firstName = textField.text
    }
}
class CreateLastNameCell:UITableViewCell, UITextFieldDelegate {
    var viewController: CreateAccountViewController?
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
        viewController?.changeTextField(from: self.tag)
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isHighlighted = false
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        viewController!.lastName = textField.text
    }
}
