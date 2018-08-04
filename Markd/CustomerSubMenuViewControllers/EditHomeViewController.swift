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
            print("Set state to \(state!)")
            tableView.reloadData()
        }
    }
    
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
        return 4 //TODO: change to 7
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "streetAddressCell", for: indexPath) as! EditStreetAddressCell
            cell.street = customerData?.getStreet()
            cell.viewController = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityAddressCell", for: indexPath) as! EditCityAddressCell
            cell.city = customerData?.getCity()
            cell.viewController = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stateAddressCell", for: indexPath) as! EditStateAddressCell
            if state == nil && customerData?.getState() != nil {
                print("Resetting state")
                state = customerData?.getState()
            }
            cell.state = state
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "zipAddressCell", for: indexPath) as! EditZipAddressCell
            cell.zipcode = customerData?.getZipcode()
            cell.viewController = self
            return cell
        }
        //TODO add 2, 4, 5, 6
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectStateSegue" {
            let destination = segue.destination as! SelectStateViewController
            destination.delegate = self
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
        //viewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //viewController!.change("Manufacturer", at: self.tag, to: textField.text!)
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
        //viewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //viewController!.change("Manufacturer", at: self.tag, to: textField.text!)
    }
}
class EditStateAddressCell: UITableViewCell {
    var state:String? {
        didSet {
            if state != nil {
                print("Table Cell setting state to \(state!)")
            } else {
                print("State is nil")
            }
            StringUtilities.set(textOf: stateLabel, to: state)
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
        //viewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //viewController!.change("Manufacturer", at: self.tag, to: textField.text!)
    }
}
class EditBedroomNumberCell: UITableViewCell {
    
}
class EditBathroomNumberCell: UITableViewCell {
    
}
class EditSquareFootageCell: UITableViewCell {
    
}
