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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
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
            cell.viewController = self
            cell.email = authentication.getCurrentUser()?.email
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordConfirmationCell", for: indexPath) as! ConfirmPasswordCell
            cell.viewController = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            if let title = customerData?.getTitle() {
                cell.textLabel?.text = title
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstNameCell", for: indexPath) as! FirstNameCell
            cell.viewController = self
            cell.firstName = customerData?.getFirstName()
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastNameCell", for: indexPath) as! LastNameCell
            cell.viewController = self
            cell.lastName = customerData?.getLastName()
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "maritalStatusCell", for: indexPath)
            if let status = customerData?.getMaritalStatus() {
                cell.textLabel?.text = status
            }
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            AlertControllerUtilities.showActionSheet(withTitle: "Which title do you prefer?", andMessage: nil, withOptions: [
                    UIAlertAction(title: "Mr.", style: .default, handler: nil),
                    UIAlertAction(title: "Mrs.", style: .default, handler: nil),
                    UIAlertAction(title: "Ms.", style: .default, handler: nil),
                    UIAlertAction(title: "Dr.", style: .default, handler: nil),
                    UIAlertAction(title: "Rev.", style: .default, handler: nil),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ],
               in: self)
        } else if indexPath.row == 5 {
            AlertControllerUtilities.showActionSheet(withTitle: "Current Marital Status", andMessage: nil, withOptions: [
                UIAlertAction(title: "Single", style: .default, handler: nil),
                UIAlertAction(title: "Married", style: .default, handler: nil),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ],
                 in: self)
        }
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
        AlertControllerUtilities.somethingWentWrong(with: self)
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
        //viewController!.address.setStreet(textField.text!)
    }
}
class ConfirmPasswordCell:UITableViewCell, UITextFieldDelegate {
    var viewController: EditProfileViewController?
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet {
            //confirmPasswordTextField.delegate = self
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
        //viewController!.address.setStreet(textField.text!)
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
        //viewController!.address.setStreet(textField.text!)
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
        //viewController!.address.setStreet(textField.text!)
    }
}
