//
//  EditPanelViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/16/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditPanelViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    var customerData:TempCustomerData?
    var panelIndex:Int? {
        didSet {
            if panelIndex == nil || panelIndex! < 0 {
                self.title = "Add Panel"
            } else {
                self.title = "Edit Panel"
            }
        }
    }
    var numberOfBreakers:Int?
    var panel:Panel? {
        didSet {
            numberOfBreakers = panel!.numberOfBreakers
            self.tableView.reloadData()
        }
    }
    var isEditingManufacturer:Bool = false
    var isEditingInstallDate:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Panel"
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        
        if let customerData = customerData, let number = panelIndex, let panel = panel {
            super.viewWillDisappear(animated)
            if number < 0 {
                customerData.updatePanel(at:number, to: panel.setNumberOfBreakers(numberOfBreakers!))
            } else {
                customerData.updatePanel(at:number, to: panel.setNumberOfBreakers(numberOfBreakers!))
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
        if isEditingManufacturer || isEditingInstallDate {
            return 7
        } else {
            return 6
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "panelDescriptionTableCell", for: indexPath) as! PanelDescriptionTableViewCell
            cell.editPanelViewController = self
            cell.panelDescription = panel?.panelDescription
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "breakerNumberTableCell", for: indexPath) as! NumberOfBreakersTableViewCell
            cell.editPanelViewController = self
            cell.numberOfBreakers = panel?.numberOfBreakers
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "isSubPanelTableCell", for: indexPath) as! IsSubPanelTableViewCell
            cell.editPanelViewController = self
            if let isMainPanel = panel?.isMainPanel {
                cell.isSubPanel = !isMainPanel
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "panelAmperageTableCell", for: indexPath) as! PanelAmperageTableViewCell
            cell.editPanelViewController = self
            cell.panelAmperage = panel?.amperage
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "manufacturerTableCell", for: indexPath) as! ManufacturerTableViewCell
            cell.manufacturer = panel?.manufacturer
            return cell
        } else if indexPath.row == 5 && isEditingManufacturer {
            let cell = tableView.dequeueReusableCell(withIdentifier: "manufacturerPickerTableCell", for: indexPath) as! ManufacturerPickerTableViewCell
            cell.editPanelViewController = self
            return cell
        } else if isInstallDateRow(for: indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "panelInstallDateTableCell", for: indexPath) as! PanelInstallDateTableViewCell
            cell.installDate = panel?.installDate
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "panelInstallDatePickerTableCell", for: indexPath) as! PanelDatePickerTableViewCell
            cell.installDate = panel?.installDate
            cell.editPanelViewController = self
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < 4 {
            hideEditCells()
        } else if indexPath.row == 4 {
            hideEditInstallDatePicker()
            toggleEditManufacturer()
        } else if isInstallDateRow(for: indexPath.row) {
            hideEditManufacturerPicker()
            toggleEditInstallDate()
        }
    }
    private func isInstallDateRow(for row:Int) -> Bool {
        if row == 5 && !isEditingManufacturer {
            return true
        } else if row == 6 && isEditingManufacturer {
            return true
        }
        return false
    }
    
    //Mark:- Helpers
    func toggleEditManufacturer() {
        self.view.endEditing(true)
        if(isEditingManufacturer) {
            hideEditManufacturerPicker()
        } else {
            showEditManufacturerPicker()
        }
    }
    func toggleEditInstallDate() {
        self.view.endEditing(true)
        if(isEditingInstallDate) {
            hideEditInstallDatePicker()
        } else {
            showEditInstallDatePicker()
        }
    }
    func showEditManufacturerPicker() {
        if(!isEditingManufacturer) {
            tableView.beginUpdates()
            isEditingManufacturer = true
            tableView.insertRows(at: [IndexPath(row: 5, section: 0)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditManufacturerPicker() {
        if(isEditingManufacturer) {
            tableView.beginUpdates()
            isEditingManufacturer = false
            tableView.deleteRows(at: [IndexPath(row: 5, section: 0)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func showEditInstallDatePicker() {
        if(!isEditingInstallDate) {
            tableView.beginUpdates()
            isEditingInstallDate = true
            tableView.insertRows(at: [IndexPath(row: 6, section: 0)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditInstallDatePicker() {
        if(isEditingInstallDate) {
            tableView.beginUpdates()
            isEditingInstallDate = false
            tableView.deleteRows(at: [IndexPath(row: 6, section: 0)], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
    }
    func hideEditCells() {
        hideEditManufacturerPicker()
        hideEditInstallDatePicker()
    }
    
    //Mark: OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("EditPanelViewController:- Got Customer Data")
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}

//Mark:- TableViewCells
class PanelDescriptionTableViewCell: UITableViewCell, UITextFieldDelegate {
    var editPanelViewController:EditPanelViewController?
    @IBOutlet weak var panelDescriptionTextField: UITextField! {
        didSet {
            panelDescriptionTextField.delegate = self
        }
    }
    var panelDescription:String? {
        didSet {
            panelDescriptionTextField.text = panelDescription
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editPanelViewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        editPanelViewController!.panel!.panelDescription = textField.text!
    }
}

class NumberOfBreakersTableViewCell: UITableViewCell {
    @IBOutlet weak var numberOfBreakersLabel: UILabel!
    @IBOutlet weak var breakerStepper: UIStepper!
    
    @IBAction func onBreakerStepperValueChanged(_ sender: UIStepper) {
        numberOfBreakers = Int(sender.value)
        editPanelViewController!.numberOfBreakers = numberOfBreakers
    }
    var editPanelViewController:EditPanelViewController?
    var numberOfBreakers:Int? {
        didSet {
            numberOfBreakersLabel.text = "\(numberOfBreakers!) breakers"
            breakerStepper.value = Double(numberOfBreakers!)
        }
    }
}

class IsSubPanelTableViewCell: UITableViewCell {
    var editPanelViewController:EditPanelViewController?
    @IBOutlet weak var isSubPanelSwitch: UISwitch!
    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        isSubPanel = sender.isOn
        if let isSubPanel = isSubPanel {
            let isMainPanel = !isSubPanel
            editPanelViewController!.panel!.isMainPanel = isMainPanel
            if isMainPanel {
                editPanelViewController!.panel!.amperage = MainPanelAmperage(rawValue: 0)!.description
            } else {
                editPanelViewController!.panel!.amperage = SubPanelAmperage(rawValue: 0)!.description
            }
            editPanelViewController!.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        }
    }
    
    var isSubPanel:Bool? {
        didSet {
            isSubPanelSwitch.isOn = isSubPanel!
        }
    }
}

class PanelAmperageTableViewCell: UITableViewCell {
    var editPanelViewController:EditPanelViewController?
    
    @IBOutlet weak var panelAmperageStepper: UIStepper!
    @IBOutlet weak var panelAmperageLabel: UILabel!
    
    var panelAmperage:String? {
        didSet {
            panelAmperageLabel.text = panelAmperage
            let isMainPanel = editPanelViewController!.panel!.isMainPanel
            if isMainPanel {
                panelAmperageStepper.minimumValue = 0
                panelAmperageStepper.maximumValue = Double(MainPanelAmperage.count - 1)
                panelAmperageStepper.value = Double(MainPanelAmperage.getRawValue(from: panelAmperage).rawValue)
            } else {
                panelAmperageStepper.minimumValue = 0
                panelAmperageStepper.maximumValue = Double(SubPanelAmperage.count - 1)
                panelAmperageStepper.value = Double(SubPanelAmperage.getRawValue(from: panelAmperage).rawValue)
            }
        }
    }
    @IBAction func onPanelAmperageStepperValueChanged(_ sender: UIStepper) {
        let isMainPanel = editPanelViewController!.panel!.isMainPanel
        if isMainPanel {
            panelAmperage = MainPanelAmperage(rawValue: Int(sender.value))?.description
        } else {
            panelAmperage = SubPanelAmperage(rawValue: Int(sender.value))?.description
        }
        editPanelViewController!.panel!.amperage = panelAmperage!
    }
}

class ManufacturerTableViewCell: UITableViewCell {
    @IBOutlet weak var manufacturerLabel: UILabel!
    var manufacturer:String? {
        didSet {
            manufacturerLabel.text = manufacturer
        }
    }
}

class ManufacturerPickerTableViewCell: UITableViewCell, ManufacturerViewProtocol {
    var editPanelViewController:EditPanelViewController?
    var manufacturer: String? {
        didSet {
            editPanelViewController!.panel!.manufacturer = manufacturer!
            editPanelViewController!.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
        }
    }
    
    @IBOutlet weak var manufacturerPicker: ManufacturerPickerView! {
        didSet {
            manufacturerPicker.delegate = manufacturerPicker
            manufacturerPicker.dataSource = manufacturerPicker
            manufacturerPicker.manufacturerViewController = self
        }
    }
}

class PanelInstallDateTableViewCell: UITableViewCell {
    @IBOutlet weak var installDateLabel: UILabel!
    
    var installDate:String? {
        didSet {
            installDateLabel.text = installDate
        }
    }
}

class PanelDatePickerTableViewCell: UITableViewCell {
    var editPanelViewController:EditPanelViewController?
    
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
        let panelToUpdate = editPanelViewController!.panel!
        
        if let numberOfBreakers = editPanelViewController?.numberOfBreakers {
            panelToUpdate.numberOfBreakers = numberOfBreakers
        }
        editPanelViewController!.panel = panelToUpdate.setInstallDate(
            month: calendar.component(Calendar.Component.month, from: sender.date),
            day: calendar.component(Calendar.Component.day, from: sender.date),
            year: calendar.component(Calendar.Component.year, from: sender.date))
    }
}


