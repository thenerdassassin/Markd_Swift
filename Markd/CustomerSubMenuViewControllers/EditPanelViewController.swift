//
//  EditPanelViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/16/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditPanelViewController: UITableViewController {
    var panel:Panel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Panel"
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Mark:- Helpers
    func hideEditCells() {
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
        editPanelViewController!.panel!.setNumberOfBreakers(numberOfBreakers!)
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


