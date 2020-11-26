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
    public var delegate: ApplianceViewController?
    public var customerData:TempCustomerData?
    let cellIdentifier = "editApplianceCell"

    public var index: Int = -1
    public var appliance:Appliance? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public var viewTitle = "Edit"
    
    var isEditingField:(Bool, Bool) = (false, false) // 0 == isEditingInstallDate, 1 == isEditingLifeSpan

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
        self.view.endEditing(true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //AirHandler/Compressor or Boiler/Hot Water
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Manufacturer, Model, InstallDate, LifeSpan
        if isEditing() {
            return 5
        }
        return 4
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appliance = appliance else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editManufacturerCell", for: indexPath) as! EditManufacturerCell
            cell.manufacturer = appliance.getManufacturer()
            cell.viewController = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editModelCell", for: indexPath) as! EditModelCell
            cell.model = appliance.getModel()
            cell.viewController = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "applianceInstallDateCell", for: indexPath) as! ApplianceInstallDateCell
            cell.installDate = appliance.installDateAsString()
            return cell
        } else if isLifeSpanRow(for: indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lifeSpanCell", for: indexPath) as! ApplianceLifeSpanCell
            cell.lifeSpan = appliance.lifeSpanAsString()
            return cell
        } else if indexPath.row == 3 {
            //Install Date Picker installDatePickerCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "installDatePickerCell", for: indexPath) as! ApplianceInstallDatePickerCell
            cell.viewController = self
            cell.installDate = appliance.installDateAsString()
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editLifeSpanCell", for: indexPath) as! ApplianceEditLifeSpanCell
            cell.viewController = self
            cell.lifeSpan = appliance.lifeSpanAsString()
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        switch appliance {
        case is Boiler:
            return "Boiler"
        case is HotWater:
            return "Hot Water"
        case is AirHandler:
            return "Air Handler"
        case is Compressor:
            return "Compressor"
        default:
            return "Appliance"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //0=Manufacturer, 1==Model, 2==Date, 3==LifeSpan
        if indexPath.row < 2 {
            hideEditCells()
        } else if indexPath.row == 2 {
            toggleEditInstallDate()
        } else if isLifeSpanRow(for: indexPath.row) {
            toggleEditLifeSpan()
        }
    }
    
    //Mark:- Helpers
    func toggleEditInstallDate() {
        self.view.endEditing(true)
        hideEditLifeSpanPicker()
        if isEditingField.0 {
            hideEditInstallDatePicker()
        } else {
            showEditInstallDatePicker()
        }
    }
    func toggleEditLifeSpan() {
        self.view.endEditing(true)
        hideEditInstallDatePicker()
        if isEditingField.1 {
            hideEditLifeSpanPicker()
        } else {
            showEditLifeSpanPicker()
        }
    }
    func showEditInstallDatePicker() {
        if !isEditingField.0 {
            tableView.beginUpdates()
            isEditingField.0 = true
            tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: UITableView.RowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditInstallDatePicker() {
        if isEditingField.0 {
            tableView.beginUpdates()
            isEditingField.0 = false
            tableView.deleteRows(at: [IndexPath(row: 3, section: 0)], with: UITableView.RowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func showEditLifeSpanPicker() {
        if !isEditingField.1 {
            tableView.beginUpdates()
            isEditingField.1 = true
            tableView.insertRows(at: [IndexPath(row: 4, section: 0)], with: UITableView.RowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditLifeSpanPicker() {
        if isEditingField.1 {
            tableView.beginUpdates()
            isEditingField.1 = false
            tableView.deleteRows(at: [IndexPath(row: 4, section: 0)], with: UITableView.RowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditCells() {
        hideEditLifeSpanPicker()
        hideEditInstallDatePicker()
    }
    
    public func change(_ field: String, to updatedValue: String, shouldReloadTable: Bool = false) {
        print("Changing \(field) to \(updatedValue)")
        guard let updatedAppliance = appliance else { return }
        updatedAppliance.set(field, to: updatedValue)
        print(updatedAppliance)
        if let customerData = customerData {
            self.index = customerData.setAppliance(to: updatedAppliance, at: index)
            if shouldReloadTable {
                self.tableView.reloadData()
            }
        } else {
            print("TempCustomerData is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
        }
    }
    private func isEditing() -> Bool {
        return isEditingField.0 || isEditingField.1
    }
    private func isLifeSpanRow(for row:Int) -> Bool {
        if row == 3 && !isEditingField.0 {
            return true
        } else if row == 4 && isEditingField.0 {
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
        viewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        viewController!.change("Manufacturer", to: textField.text!)
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
        viewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        viewController!.change("Model", to: textField.text!)
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

public class ApplianceInstallDatePickerCell: UITableViewCell {
    var viewController:EditApplianceTableViewController?
    
    @IBOutlet weak var installDatePicker: UIDatePicker! {
        didSet {
            installDatePicker.maximumDate = Date()
            set(to: installDate)
        }
    }
    public var installDate:String? {
        didSet {
            set(to: installDate)
        }
    }
    func set(to date: String?) {
        if let date = installDate {
            StringUtilities.set(installDatePicker, to: date)
        }
    }
    
    @IBAction func installDatePickerValueChanged(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let newDate = StringUtilities.getDateString(
            withMonth: calendar.component(Calendar.Component.month, from: sender.date),
            withDay: calendar.component(Calendar.Component.day, from: sender.date),
            withYear: calendar.component(Calendar.Component.year, from: sender.date))
        viewController!.change("Install Date", to: newDate!, shouldReloadTable: true)
    }
}

public class ApplianceEditLifeSpanCell: UITableViewCell {
    var viewController:EditApplianceTableViewController?
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lifeSpanSlider: UISlider!
    
    var units = ["days", "months", "years"]
    
    var lifeSpan: String? {
        didSet {
            if(StringUtilities.isNilOrEmpty(lifeSpan)) {
                print("Life Span was null or empty")
                self.lifeSpan = "10 years"
                setLifeSpan("10 years")
            } else {
                print("Setting life span")
                setLifeSpan(lifeSpan)
            }
        }
    }
    func setLifeSpan(_ lifeSpan: String?) {
        guard let lifeSpanCompenents = self.lifeSpan?.split(separator: " ") else {
            print("Not able to get lifeSpanComponents")
            return
        }
        
        guard lifeSpanCompenents.count == 2 else {
            print("Number of Components was \(lifeSpanCompenents.count)")
            return
        }
        
        guard let lifeSpanValue = Float("\(lifeSpanCompenents[0])") else {
            print("LifeSpanValue not able to be initialized")
            return
        }
        
        switch lifeSpanCompenents[1] {
        case "days":
            unitsSegmentedControl.selectedSegmentIndex = 0
            lifeSpanSlider.minimumValue = 1
            lifeSpanSlider.maximumValue = 365
            lifeSpanSlider.value = lifeSpanValue
            break
        case "months":
            unitsSegmentedControl.selectedSegmentIndex = 1
            lifeSpanSlider.minimumValue = 1
            lifeSpanSlider.maximumValue = 12
            lifeSpanSlider.value = lifeSpanValue
            break
        default:
            unitsSegmentedControl.selectedSegmentIndex = 2
            lifeSpanSlider.minimumValue = 1
            lifeSpanSlider.maximumValue = 50
            lifeSpanSlider.value = lifeSpanValue
            break
        }
    }
    @IBAction func onUnitsValueChanged(_ sender: UISegmentedControl) {
        let unitsSelected = units[sender.selectedSegmentIndex]
        switch unitsSelected {
        case "days":
            lifeSpanSlider.minimumValue = 1
            lifeSpanSlider.maximumValue = 365
            lifeSpanSlider.setValue(100, animated: true)
            break
        case "months":
            lifeSpanSlider.minimumValue = 1
            lifeSpanSlider.maximumValue = 12
            lifeSpanSlider.setValue(6, animated: true)
            break
        default:
            lifeSpanSlider.minimumValue = 1
            lifeSpanSlider.maximumValue = 50
            lifeSpanSlider.setValue(10, animated: true)
            break
        }
        self.onLifeSpanValueChanged(lifeSpanSlider)
    }
    
    @IBAction func onLifeSpanValueChanged(_ slider: UISlider) {
        let updatedLifeSpan = "\(Int(round(slider.value))) \(units[unitsSegmentedControl.selectedSegmentIndex])"
        viewController!.change("Projected Life Span", to: updatedLifeSpan)
        viewController!.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: UITableView.RowAnimation.none)
    }
}
