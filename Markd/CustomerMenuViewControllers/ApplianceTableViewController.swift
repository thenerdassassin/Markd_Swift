//
//  ApplianceTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 11/13/20.
//  Copyright © 2020 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ApplianceTableViewController:UITableViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData?
    var delegate: ApplianceViewController?
    var isPlumbing: Bool = true
    var sectionOneAppliances:[Appliance]? {
        didSet {
            if let tableView = self.tableView {
                tableView.reloadSections([0], with: .fade)
            }
        }
    }
    var sectionTwoAppliances:[Appliance]? {
        didSet {
            if let tableView = self.tableView {
                tableView.reloadSections([1], with: .fade)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    private func configureView() {
        if let _ = customerData {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let appliances = sectionOneAppliances {
                if appliances.count != 0 {
                    return appliances.count
                }
            }
        } else if section == 1 {
            if let appliances = sectionTwoAppliances {
                if appliances.count != 0 {
                    return appliances.count
                }
            }
        }
        return 1
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if (isPlumbing) {
            switch section {
            case 0:
                return "Boiler"
            case 1:
                return "Hot Water"
            default:
                break
            }
        } else {
            switch section {
            case 0:
                return "Compressor"
            case 1:
                return "Air Handler"
            default:
                break
            }
        }
        
        return "Appliances"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let applianceCell = tableView.dequeueReusableCell(withIdentifier: "applianceCell", for: indexPath) as! ApplianceTableViewCell
        applianceCell.tag = indexPath.section
        applianceCell.index = indexPath.row
        
        var appliance:Appliance?
        
        if indexPath.section == 0 && sectionOneAppliances != nil && sectionOneAppliances!.count > indexPath.row {
            appliance = sectionOneAppliances?[indexPath.row]
        } else if indexPath.section == 1 && sectionTwoAppliances != nil && sectionTwoAppliances!.count > indexPath.row {
            appliance = sectionTwoAppliances?[indexPath.row]
        } else if indexPath.section > 1 {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
        
        if let appliance = appliance {
            applianceCell.appliance = appliance
            return applianceCell
        }
        return tableView.dequeueReusableCell(withIdentifier: "applianceDefaultCell", for: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 0 && sectionOneAppliances != nil && sectionOneAppliances!.count > 0) ||
            (indexPath.section == 1 && sectionTwoAppliances != nil && sectionTwoAppliances!.count > 0)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            
            guard let applianceCell = tableView.cellForRow(at: indexPath) as? ApplianceTableViewCell else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            
            switch (applianceCell.appliance) {
            case is Boiler:
                customerData.removeBoiler(at: indexPath.row)
                delegate?.customerData = customerData
            case is HotWater:
                customerData.removeHotWater(at: indexPath.row)
                delegate?.customerData = customerData
            case is Compressor:
                customerData.removeCompressor(at: indexPath.row)
                delegate?.customerData = customerData
            case is AirHandler:
                customerData.removeAirHandler(at: indexPath.row)
                delegate?.customerData = customerData
            default:
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editApplianceSegue" {
            let sender = sender as! ApplianceTableViewCell
            let destination = segue.destination as! EditApplianceTableViewController
            destination.delegate = delegate
            guard let customerData = customerData, let appliance = sender.appliance, let index = sender.index else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            destination.index = index
            destination.appliance = appliance
        }
    }
}

class ApplianceTableViewCell:UITableViewCell {
    var index:Int?
    var appliance:Appliance? {
        didSet {
            switch appliance {
            case is HotWater:
                label.text = "Hot Water \((index ?? 1) + 1)"
            case is Boiler:
                label.text = "Boiler \((index ?? 1) + 1)"
            case is Compressor:
                label.text = "Compressor \((index ?? 1) + 1)"
            case is AirHandler:
                label.text = "Air Handler \((index ?? 1) + 1)"
            default:
                label.text = "Appliance \((index ?? 1) + 1)"
            }
        }
    }
    @IBOutlet weak var label: UILabel!
}
