//
//  EditHomeViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 8/4/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class EditHomeViewController: UITableViewController, OnGetDataListener, StatePickerViewProtocol {
    private let authentication = FirebaseAuthentication.sharedInstance
    var customerData: TempCustomerData?
    var state: String? {
        didSet {
            tableView.reloadData()
        }
    }
    var address = Address()
    var bedrooms: String?
    var bathrooms: String?
    var squareFootage: String?
    
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
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        updateHome()
        updateAddress()
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
        return 7
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "streetAddressCell", for: indexPath) as! EditStreetAddressCell
            cell.street = customerData?.getStreet()
            if let street = customerData?.getStreet() {
                address.setStreet(street)
            }
            cell.viewController = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityAddressCell", for: indexPath) as! EditCityAddressCell
            cell.city = customerData?.getCity()
            if let city = customerData?.getCity() {
                address.setCity(city)
            }
            cell.viewController = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stateAddressCell", for: indexPath) as! EditStateAddressCell
            cell.viewController = self
            if state == nil && customerData?.getState() != nil {
                state = customerData?.getState()
            }
            if let state = state {
                address.setState(state)
            }
            cell.state = state
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "zipAddressCell", for: indexPath) as! EditZipAddressCell
            cell.zipcode = customerData?.getZipcode()
            if let zipcode = customerData?.getZipcode() {
                address.setZipCode(zipcode)
            }
            cell.viewController = self
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bedroomNumberCell", for: indexPath) as! EditBedroomNumberCell
            cell.viewController = self
            if bedrooms == nil && !StringUtilities.isNilOrEmpty(customerData?.getBedrooms()) {
                bedrooms = customerData?.getBedrooms()
            }
            if let bedrooms = bedrooms, let bedroomValue = Double(bedrooms) {
                cell.bedroomStepper.value = bedroomValue
                cell.onBedroomValueChanged(cell.bedroomStepper)
            }
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bathroomNumberCell", for: indexPath) as! EditBathroomNumberCell
            cell.viewController = self
            if bathrooms == nil && !StringUtilities.isNilOrEmpty(customerData?.getBathrooms()) {
                bathrooms = customerData?.getBathrooms()
            }
            if let bathrooms = bathrooms, let bathroomValue = Double(bathrooms) {
                cell.bathroomStepper.value = bathroomValue
                cell.onBathroomValueChanged(cell.bathroomStepper)
            }
            return cell
        } else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "squareFootageCell", for: indexPath) as! EditSquareFootageCell
            cell.viewController = self
            if squareFootage == nil && !StringUtilities.isNilOrEmpty(customerData?.getSquareFootage()) {
                squareFootage = customerData?.getSquareFootage()
            }
            if let squareFootage = squareFootage, let squareFootageValue = Double(squareFootage) {
                cell.squareFootageStepper.value = squareFootageValue
                cell.onSquareFootageValueChanged(cell.squareFootageStepper)
            }
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectStateSegue" {
            let destination = segue.destination as! SelectStateViewController
            destination.delegate = self
        }
    }
    
    //Mark:- Helper
    private func updateHome() {
        let updatedHome = Home()
        if let bedrooms = bedrooms {
            updatedHome.setBedrooms(Double(bedrooms)!)
        }
        if let bathrooms = bathrooms {
            updatedHome.setBathrooms(Double(bathrooms)!)
        }
        if let squareFootage = squareFootage {
            updatedHome.setSquareFootage(Int(squareFootage)!)
        }
        if let customerData = customerData {
            customerData.updateHome(to: updatedHome)
        }
    }
    private func updateAddress() {
        if let customerData = customerData {
            customerData.updateAddress(to: address)
        }
    }
    //Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Data")
    }
    
    public func onSuccess() {
        print("EditHomeViewController:- Got Customer Data")
        tableView.reloadData()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}

class EditStreetAddressCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditHomeViewController?
    @IBOutlet weak var streetAddressTextField: UITextField! {
        didSet {
            streetAddressTextField.delegate = self
        }
    }
    var street:String? {
        didSet {
            streetAddressTextField.text = street
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
        viewController!.address.setStreet(textField.text!)
    }
}
class EditCityAddressCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditHomeViewController?
    @IBOutlet weak var cityAddressTextField: UITextField! {
        didSet {
            cityAddressTextField.delegate = self
        }
    }
    var city:String? {
        didSet {
            cityAddressTextField.text = city
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
        viewController!.address.setCity(textField.text!)
    }
}
class EditStateAddressCell: UITableViewCell {
    var viewController: EditHomeViewController?
    var state:String? {
        didSet {
            StringUtilities.set(textOf: stateLabel, to: state)
            if let state = state {
                viewController!.address.setState(state)
            }
        }
    }
    @IBOutlet weak var stateLabel: UILabel!
}
class EditZipAddressCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditHomeViewController?
    @IBOutlet weak var zipAddressTextField: UITextField! {
        didSet {
            zipAddressTextField.delegate = self
        }
    }
    var zipcode:String? {
        didSet {
            zipAddressTextField.text = zipcode
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
        viewController!.address.setZipCode(textField.text!)
    }
}
class EditBedroomNumberCell: UITableViewCell {
    var viewController: EditHomeViewController?
    @IBOutlet weak var bedroomsLabel: UILabel!
    @IBOutlet weak var bedroomStepper: UIStepper!
    
    @IBAction func onBedroomValueChanged(_ sender: UIStepper) {
        let bedrooms = sender.value
        viewController!.bedrooms = "\(bedrooms)"
        if bedrooms > 1 {
            bedroomsLabel.text = "\(bedrooms) bedrooms"
        } else {
            bedroomsLabel.text = "\(bedrooms) bedroom"
        }
    }
}
class EditBathroomNumberCell: UITableViewCell {
    var viewController: EditHomeViewController?
    @IBOutlet weak var bathroomsLabel: UILabel!
    @IBOutlet weak var bathroomStepper: UIStepper!
    
    @IBAction func onBathroomValueChanged(_ sender: UIStepper) {
        let bathrooms = sender.value
        viewController!.bathrooms = "\(bathrooms)"
        if bathrooms > 1 {
            bathroomsLabel.text = "\(bathrooms) bathrooms"
        } else {
            bathroomsLabel.text = "\(bathrooms) bathroom"
        }
    }
}
class EditSquareFootageCell: UITableViewCell {
    var viewController: EditHomeViewController?
    @IBOutlet weak var squareFootageLabel: UILabel!
    @IBOutlet weak var squareFootageStepper: UIStepper!
    
    @IBAction func onSquareFootageValueChanged(_ sender: UIStepper) {
        let squareFootage = Int(round(sender.value))
        viewController!.squareFootage = "\(squareFootage)"
        squareFootageLabel.text = "\(squareFootage) sq ft"
    }
}
