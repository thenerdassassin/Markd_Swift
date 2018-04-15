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

    public var appliances = [Appliance]()
    public var viewTitle = "Edit"

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
        return 4 //Manufacturer, Model, InstallDate, LifeSpan
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EditApplianceTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EditApplianceTableViewCell.")
        }
        if(appliances.count <= indexPath.section) {
            print("No Appliance at index: \(indexPath.section)")
            return cell
        }
        
        cell.tag = indexPath.section
        let appliance = appliances[indexPath.section]
        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "Manufacturer"
            if(!StringUtilities.isNilOrEmpty(appliance.getManufacturer())) {
                cell.textField.text = appliance.getManufacturer()
            }
        case 1:
            cell.textField.placeholder = "Model"
            if(!StringUtilities.isNilOrEmpty(appliance.getModel())) {
                cell.textField.text = appliance.getModel()
            }
        case 2:
            cell.textField.placeholder = "Install Date"
            if(!StringUtilities.isNilOrEmpty(appliance.getModel())) {
                cell.textField.text = appliance.installDateAsString()
            }
        case 3:
            cell.textField.placeholder = "Projected Life Span"
            if(!StringUtilities.isNilOrEmpty(appliance.getModel())) {
                cell.textField.text = appliance.lifeSpanAsString()
            }
        default:
            fatalError("No case for: \(indexPath.row)")
        }

        return cell
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editApplianceFieldSegue") {
            guard let destination = segue.destination as? EditApplianceFieldViewController else {
                fatalError("Destination not instance of EditApplianceFieldViewController")
            }
            guard let sender = sender as? EditApplianceTableViewCell else {
                fatalError("The sender is not an instance of EditApplianceTableViewCell.")
            }
            
            destination.applianceIndex = sender.tag
            destination.originalValue = sender.textField.text
            destination.fieldEditing = sender.textField.placeholder
            destination.delegate = self
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
}

public class EditApplianceTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
}
