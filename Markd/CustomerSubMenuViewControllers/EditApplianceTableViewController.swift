//
//  EditApplianceTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/10/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditApplianceTableViewController: UITableViewController {
    let cellIdentifier = "editApplianceCell"

    public var appliances = [Appliance]()
    public var viewTitle = "Edit"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewTitle
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if(section == 0) {
                return "Boiler"
            } else {
                return "Hot Water"
            }
        } else if(viewTitle.lowercased().contains("hvac")) {
            if(section == 0) {
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
            guard let destination = segue.destination as? ApplianceEditFieldViewController else {
                fatalError("Destination not instance of ApplianceEditFieldViewController")
            }
            guard let sender = sender as? EditApplianceTableViewCell else {
                fatalError("The sender is not an instance of EditApplianceTableViewCell.")
            }
            
            destination.applianceIndex = sender.tag
            destination.originalValue = sender.textField.text
            
            switch sender.textField.placeholder {
            case "Manufacturer":
                destination.editType = "String"
            case "Model":
                destination.editType = "String"
            case "Install Date":
                destination.editType = "Date"
            case "Projected Life Span":
                destination.editType = "LifeSpan"
            default:
                fatalError("No case for: \(sender.textField.placeholder!)")
            }
        }
    }
}

public class EditApplianceTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
}
