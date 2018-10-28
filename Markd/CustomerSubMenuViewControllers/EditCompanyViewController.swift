//
//  EditCompanyViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 10/27/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class EditCompanyViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    var contractorData: TempContractorData?
    var contractorDetails = ContractorDetails([:])
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authentication.checkLogin(self) {
            contractorData = TempContractorData(self)
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
        if isValidInput() {
            updateContractorDetails()
        }
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let contractorData = contractorData {
            contractorData.removeListeners()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyNameCell", for: indexPath) as! EditCompanyNameCell
            if !StringUtilities.isNilOrEmpty(contractorDetails.getCompanyName()) {
                cell.companyName = contractorDetails.getCompanyName()
            } else {
                cell.companyName = contractorData?.getContractorDetails()?.getCompanyName()
                if let companyName = cell.companyName {
                    let _ = contractorDetails.setCompanyName(to: companyName)
                    navigationItem.hidesBackButton = !isValidInput()
                }
            }
            cell.viewController = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyTelephoneCell", for: indexPath) as! EditCompanyTelephoneCell
            if !StringUtilities.isNilOrEmpty(contractorDetails.getTelephoneNumber()) {
                cell.telephoneNumber = contractorDetails.getTelephoneNumber()
            } else {
                cell.telephoneNumber = contractorData?.getContractorDetails()?.getTelephoneNumber()
                if let telephoneNumber = cell.telephoneNumber {
                    let _ = contractorDetails.setTelephoneNumber(to: telephoneNumber)
                    navigationItem.hidesBackButton = !isValidInput()
                }
            }
            cell.viewController = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyWebsiteCell", for: indexPath) as! EditCompanyWebsiteCell
            if !StringUtilities.isNilOrEmpty(contractorDetails.getWebsiteUrl()) {
                cell.website = contractorDetails.getWebsiteUrl()
            } else {
                cell.website = contractorData?.getContractorDetails()?.getWebsiteUrl()
                if let website = cell.website {
                    let _ = contractorDetails.setWebsiteUrl(to: website)
                    navigationItem.hidesBackButton = !isValidInput()
                }
            }
            cell.viewController = self
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyZipcodeCell", for: indexPath) as! EditCompanyZipcodeCell
            if !StringUtilities.isNilOrEmpty(contractorDetails.getZipCode()) {
                cell.zipCode = contractorDetails.getZipCode()
            } else {
                cell.zipCode = contractorData?.getContractorDetails()?.getZipCode()
                if let zipCode = cell.zipCode {
                    let _ = contractorDetails.setZipCode(to: zipCode)
                    navigationItem.hidesBackButton = !isValidInput()
                }
            }
            cell.viewController = self
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func isValidInput() -> Bool {
        return !StringUtilities.isNilOrEmpty(contractorDetails.getCompanyName()) && !StringUtilities.isNilOrEmpty(contractorDetails.getTelephoneNumber()) && contractorDetails.getTelephoneNumber()!.count == 14 && !StringUtilities.isNilOrEmpty(contractorDetails.getWebsiteUrl()) && !StringUtilities.isNilOrEmpty(contractorDetails.getZipCode()) && contractorDetails.getZipCode().count == 5
    }
    
    func updateContractorDetails() {
        if let contractorData = contractorData {
            contractorData.updateContractorDetails(to: contractorDetails)
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
        }
    }
    
    //Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Data")
    }
    
    public func onSuccess() {
        print("EditCompanyViewController:- Got Contractor Data")
        tableView.reloadData()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}

class EditCompanyNameCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditCompanyViewController?
    @IBOutlet weak var companyNameTextField: UITextField! {
        didSet {
            companyNameTextField.delegate = self
        }
    }
    
    var companyName:String? {
        didSet {
            companyNameTextField.text = companyName
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
        let _ = viewController!.contractorDetails.setCompanyName(to: textField.text!)
        viewController!.navigationItem.hidesBackButton = !viewController!.isValidInput()
    }
}
class EditCompanyTelephoneCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditCompanyViewController?
    @IBOutlet weak var companyTelephoneTextField: UITextField! {
        didSet {
            companyTelephoneTextField.delegate = self
        }
    }
    
    var telephoneNumber:String? {
        didSet {
            if let telephoneNumber = telephoneNumber {
                companyTelephoneTextField.text = StringUtilities.format(phoneNumber: telephoneNumber)
            } else {
                companyTelephoneTextField.text = telephoneNumber
            }
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
        viewController!.contractorDetails.setTelephoneNumber(to: textField.text!)
        viewController!.navigationItem.hidesBackButton = !viewController!.isValidInput()
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            if txtAfterUpdate.count < textField.text!.count {
                return true
            } else if (txtAfterUpdate.count > 14) {
                return false
            } else {
                textField.text = StringUtilities.format(phoneNumber: txtAfterUpdate, isStrict: false)
            }
        }
        return false
    }
}
class EditCompanyWebsiteCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditCompanyViewController?
    @IBOutlet weak var companyWebsiteTextField: UITextField! {
        didSet {
            companyWebsiteTextField.delegate = self
        }
    }
    
    var website:String? {
        didSet {
            companyWebsiteTextField.text = website
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
        let _ = viewController!.contractorDetails.setWebsiteUrl(to: textField.text!)
        viewController!.navigationItem.hidesBackButton = !viewController!.isValidInput()
    }
}
class EditCompanyZipcodeCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditCompanyViewController?
    @IBOutlet weak var companyZipcodeTextField: UITextField! {
        didSet {
            companyZipcodeTextField.delegate = self
        }
    }
    
    var zipCode:String? {
        didSet {
            companyZipcodeTextField.text = zipCode
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    //Only allow changes if zipcode length stays under 5 characters
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            return txtAfterUpdate.count <= 5
        }
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = viewController!.contractorDetails.setZipCode(to: textField.text!)
        viewController!.navigationItem.hidesBackButton = !viewController!.isValidInput()
    }
}

