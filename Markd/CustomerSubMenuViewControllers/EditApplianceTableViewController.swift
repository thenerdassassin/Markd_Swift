//
//  EditApplianceTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/10/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditApplianceTableViewController: UITableViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData?
    let cellIdentifier = "editApplianceCell"
    
    var TODO_Check_If_Contractor🤯:AnyObject?

    public var appliances = [Appliance]()
    public var viewTitle = "Edit"
    //section.0 == isEditingInstallDate, section.1 == isEditingLifeSpan
    var isEditingField:[(Bool, Bool)] = [(false, false), (false, false)]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewTitle
        tableView.tableFooterView = UIView()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!authentication.checkLogin(self)) {
            print("Not logged in.")
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //AirHandler/Compressor or Boiler/Hot Water
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Manufacturer, Model, InstallDate, LifeSpan
        if isEditing(in: section) {
            return 5
        }
        return 4
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appliance = appliances[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editManufacturerCell", for: indexPath) as! EditManufacturerCell
            cell.manufacturer = appliance.getManufacturer()
            cell.viewController = self
            cell.tag = indexPath.section
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editModelCell", for: indexPath) as! EditModelCell
            cell.model = appliance.getModel()
            cell.viewController = self
            cell.tag = indexPath.section
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "applianceInstallDateCell", for: indexPath) as! ApplianceInstallDateCell
            cell.installDate = appliance.installDateAsString()
            cell.tag = indexPath.section
            return cell
        } else if isLifeSpanRow(for: indexPath.row, in: indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lifeSpanCell", for: indexPath) as! ApplianceLifeSpanCell
            cell.lifeSpan = appliance.lifeSpanAsString()
            cell.tag = indexPath.section
            return cell
        } else if indexPath.row == 3 {
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.blue
            return cell
            //Install Date Picker
        } else if indexPath.row == 4 {
            //Life Span Picker
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.green
            return cell
        } else {
            fatalError("No case for: \(indexPath.row)")
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if(viewTitle.lowercased().contains("plumbing")) {
            if let _ = appliances[section] as? Boiler {
                return "Boiler"
            } else {
                return "Hot Water"
            }
        } else if(viewTitle.lowercased().contains("hvac")) {
            if let _ = appliances[section] as? AirHandler {
                return "Air Handler"
            } else {
                return "Compressor"
            }
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //0=Man, 1==Mod, 2==Date, 3==Life
        if indexPath.row < 2 {
            hideEditCells()
        } else if indexPath.row == 2 {
            toggleEditInstallDate(in: indexPath.section)
        } else if isLifeSpanRow(for: indexPath.row, in: indexPath.section) {
            toggleEditLifeSpan(in: indexPath.section)
        }
    }
    
    //Mark:- Helpers
    func toggleEditInstallDate(in section: Int) {
        self.view.endEditing(true)
        for index in isEditingField.indices {
            hideEditLifeSpanPicker(in: index)
            if index != section {
                hideEditInstallDatePicker(in: index)
            } else {
                if isEditingField[section].0 {
                    hideEditInstallDatePicker(in: section)
                } else {
                    showEditInstallDatePicker(in: section)
                }
            }
        }
    }
    func toggleEditLifeSpan(in section: Int) {
        self.view.endEditing(true)
        for index in isEditingField.indices {
            hideEditInstallDatePicker(in: index)
            if index != section {
                hideEditLifeSpanPicker(in: index)
            } else {
                if isEditingField[section].1 {
                    hideEditLifeSpanPicker(in: section)
                } else {
                    showEditLifeSpanPicker(in: section)
                }
            }
        }
    }
    func showEditInstallDatePicker(in section: Int) {
        if !isEditingField[section].0 {
            tableView.beginUpdates()
            isEditingField[section].0 = true
            tableView.insertRows(at: [IndexPath(row: 3, section: section)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditInstallDatePicker(in section: Int) {
        if isEditingField[section].0 {
            tableView.beginUpdates()
            isEditingField[section].0 = false
            tableView.deleteRows(at: [IndexPath(row: 3, section: section)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func showEditLifeSpanPicker(in section: Int) {
        if !isEditingField[section].1 {
            tableView.beginUpdates()
            isEditingField[section].1 = true
            tableView.insertRows(at: [IndexPath(row: 4, section: section)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditLifeSpanPicker(in section: Int) {
        if isEditingField[section].1 {
            tableView.beginUpdates()
            isEditingField[section].1 = false
            tableView.deleteRows(at: [IndexPath(row: 4, section: section)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditCells() {
        for index in isEditingField.indices {
            hideEditLifeSpanPicker(in: index)
            hideEditInstallDatePicker(in: index)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editApplianceFieldSegue") {
            guard let destination = segue.destination as? EditApplianceFieldViewController else {
                fatalError("Destination not instance of EditApplianceFieldViewController")
            }
            /*
            guard let sender = sender as? EditApplianceTableViewCell else {
                fatalError("The sender is not an instance of EditApplianceTableViewCell.")
            }
 
            destination.applianceIndex = sender.tag
            destination.originalValue = sender.textField.text
            destination.fieldEditing = sender.textField.placeholder
            destination.delegate = self
                */
        }
    }
    
    public func change(_ field: String, at index:Int, to updatedValue: String) {
        print("Changing \(field) at \(index) to \(updatedValue)")
        let updatedAppliance = appliances[index]
        updatedAppliance.set(field, to: updatedValue)
        print(updatedAppliance)
        if let customerData = customerData {
            customerData.setAppliance(to: updatedAppliance)
            self.tableView.reloadData()
        } else {
            print("TempCustomerData is nil")
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
    }
    private func isEditing(in section:Int) -> Bool {
        return isEditingField[section].0 || isEditingField[section].1
    }
    private func isLifeSpanRow(for row:Int, in section:Int) -> Bool {
        if row == 3 && !isEditingField[section].0 {
            return true
        } else if row == 4 && isEditingField[section].0 {
            return true
        }
        return false
    }
}

public class EditManufacturerCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditApplianceTableViewController?
    @IBOutlet weak var manufacturerTextField: UITextField! {
        didSet {
            manufacturerTextField.delegate = self
        }
    }
    var manufacturer:String? {
        didSet {
            manufacturerTextField.text = manufacturer
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
        //editPanelViewController!.panel!.panelDescription = textField.text!
    }
}

public class EditModelCell: UITableViewCell, UITextFieldDelegate {
    var viewController: EditApplianceTableViewController?
    @IBOutlet weak var modelTextField: UITextField! {
        didSet {
            modelTextField.delegate = self
        }
    }
    var model:String? {
        didSet {
            modelTextField.text = model
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
        //editPanelViewController!.panel!.panelDescription = textField.text!
    }
}

public class ApplianceInstallDateCell: UITableViewCell {
    @IBOutlet weak var installDateTextField: UITextField!
    var installDate:String? {
        didSet {
            installDateTextField.text = installDate
        }
    }
}

public class ApplianceLifeSpanCell: UITableViewCell {
    @IBOutlet weak var lifeSpanTextField: UITextField!
    var lifeSpan:String? {
        didSet {
            lifeSpanTextField.text = lifeSpan
        }
    }
}
