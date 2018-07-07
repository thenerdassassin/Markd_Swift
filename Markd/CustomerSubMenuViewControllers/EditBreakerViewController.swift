//
//  EditBreakerViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/30/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditBreakerViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    var customerData:TempCustomerData?
    var delegate:PanelViewController?
    var panelIndex:Int?
    var breakerIndex:Int? {
        didSet {
            if breakerIndex == nil || breakerIndex! < 0 {
                self.title = "Add Breaker"
            } else {
                self.title = "Edit Breaker"
            }
        }
    }
    var breaker:Breaker? {
        didSet {
            if originalBreakerType == nil {
                originalBreakerType = breaker!.breakerType
            }
            self.tableView.reloadData()
        }
    }
    var originalBreakerType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Breaker"
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
        if let customerData = customerData, let panels = customerData.getPanels(), let panelNumber = panelIndex, let number = breakerIndex, let breaker = breaker {
            super.viewWillDisappear(animated)
            if number >= 0 {
                customerData.updatePanel(at: panelNumber, to: panels[panelNumber].editBreaker(index: number, to: breaker))
                if let delegate = delegate {
                    delegate.panel = panels[panelNumber]
                }
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
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "breakerDescriptionTableCell", for: indexPath) as! BreakerDescriptionTableCell
            cell.breakerDescription = breaker?.breakerDescription
            cell.editBreakerViewController = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "breakerAmperageTableCell", for: indexPath) as! BreakerAmperageTableCell
            cell.editBreakerViewController = self
            cell.breakerAmperage = breaker?.amperage
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "isDoublePoleTableCell", for: indexPath) as! IsDoublePoleTableViewCell
            cell.editBreakerViewController = self
            cell.isSinglePole = (breaker?.breakerType == BreakerType.singlePole.description)
            cell.originalBreakerType = originalBreakerType
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //Mark: OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("EditBreakerViewController:- Got Customer Data")
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}

class BreakerDescriptionTableCell: UITableViewCell, UITextFieldDelegate {
    var editBreakerViewController:EditBreakerViewController?
    @IBOutlet weak var breakerTextField: UITextField! {
        didSet {
            breakerTextField.delegate = self
        }
    }
    var breakerDescription:String? {
        didSet {
            breakerTextField.text = breakerDescription
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //editBreakerViewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        editBreakerViewController!.breaker!.breakerDescription = textField.text!
    }
}

class BreakerAmperageTableCell: UITableViewCell {
    var editBreakerViewController:EditBreakerViewController?
    
    @IBOutlet weak var breakerAmperageStepper: UIStepper!
    @IBOutlet weak var breakerAmperageLabel: UILabel!
    
    var breakerAmperage:String? {
        didSet {
            breakerAmperageLabel.text = breakerAmperage
            breakerAmperageStepper.minimumValue = 0
            breakerAmperageStepper.maximumValue = Double(BreakerAmperage.count - 1)
            breakerAmperageStepper.value = Double(BreakerAmperage.getRawValue(from: breakerAmperage).rawValue)
        }
    }
    @IBAction func onBreakerAmperageStepperValueChanged(_ sender: UIStepper) {
        breakerAmperage = BreakerAmperage(rawValue: Int(sender.value))?.description
        editBreakerViewController!.breaker!.amperage = breakerAmperage!
    }
}

class IsDoublePoleTableViewCell: UITableViewCell {
    var editBreakerViewController:EditBreakerViewController?
    var originalBreakerType:String?
    
    @IBOutlet weak var isDoublePoleSwitch: UISwitch!
    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        isSinglePole = !sender.isOn
        if isSinglePole == true {
            editBreakerViewController!.breaker!.breakerType = BreakerType.singlePole.description
        } else {
            if let originalBreakerType = originalBreakerType {
                if originalBreakerType == "Double-Pole Bottom" {
                    editBreakerViewController!.breaker!.breakerType = originalBreakerType
                } else {
                    editBreakerViewController!.breaker!.breakerType = BreakerType.doublePole.description
                }
            }
        }
    }
    
    var isSinglePole:Bool? {
        didSet {
            if isSinglePole! {
                isDoublePoleSwitch.isOn = false
            } else {
                isDoublePoleSwitch.isOn = true
            }
        }
    }
}
