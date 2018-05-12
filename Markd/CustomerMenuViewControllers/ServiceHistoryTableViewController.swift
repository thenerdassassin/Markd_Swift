//
//  ServiceHistoryTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/27/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ServiceHistoryTableViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData?
    let cellIdentifier = "serviceCell"
    var plumbingServices:[ContractorService]?
    var hvacServices:[ContractorService]?
    var electricalServices:[ContractorService]?
    
    var TODO_Add_Button_Markd_Header🙌🏻:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
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
        // Plumbing, Hvac, Electrical
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let plumbingServices = plumbingServices {
                if plumbingServices.count != 0 {
                    return plumbingServices.count
                }
            }
        } else if section == 1 {
            if let hvacServices = hvacServices {
                if hvacServices.count != 0 {
                    return hvacServices.count
                }
            }
        } else if section == 2 {
            if let electricalServices = electricalServices {
                if electricalServices.count != 0 {
                    return electricalServices.count
                }
            }
        }
        return 1
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Plumbing Service History"
        } else if section == 1 {
            return "Hvac Service History"
        } else if section == 2 {
            return "Electrical Service History"
        } else {
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceCell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! ServiceTableViewCell
        var service:ContractorService?
        serviceCell.tag = indexPath.section
        serviceCell.serviceIndex = indexPath.row
        
        if indexPath.section == 0 {
            service = plumbingServices?[indexPath.row]
        } else if indexPath.section == 1 {
            service = hvacServices?[indexPath.row]
        } else if indexPath.section == 2 {
            service = electricalServices?[indexPath.row]
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
        
        if let service = service {
            serviceCell.service = service
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "serviceDefaultCell", for: indexPath) as! ServiceTableViewCell
        }
        
        return serviceCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var TODO_UpdateFirebase_😬:AnyObject?
        if editingStyle == .delete {
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            // Delete the row from the data source
            if indexPath.section == 0 {
                plumbingServices!.remove(at: indexPath.row)
                customerData.removeService(indexPath.row, of: "Plumbing")
            } else if indexPath.section == 1 {
                hvacServices!.remove(at: indexPath.row)
                customerData.removeService(indexPath.row, of: "Hvac")
            } else if indexPath.section == 2 {
                electricalServices!.remove(at: indexPath.row)
                customerData.removeService(indexPath.row, of: "Electrical")
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContractorServiceSegue" {
            let sender = sender as! ServiceTableViewCell
            let destination = segue.destination as! ContractorServiceTableViewController
            guard let customerData = customerData, let service = sender.service else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            destination.service = service
            destination.serviceType = getTypeFromTag(sender.tag)
            destination.serviceIndex = sender.serviceIndex
        }
    }
    func getTypeFromTag(_ tag:Int) -> String? {
        if tag == 0 {
            return "Plumbing"
        } else if tag == 1 {
            return "Hvac"
        } else if tag == 2 {
            return "Electrical"
        }
        return nil
    }
    
    // Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("ServiceHistoryTableViewController:- Got Customer Data")
        plumbingServices = customerData!.getPlumbingServices()
        hvacServices = customerData!.getHvacServices()
        electricalServices = customerData!.getElectricalServices()
        self.tableView.reloadData()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}

public class ServiceTableViewCell: UITableViewCell {
    public var service:ContractorService? {
        didSet {
            if let service = service {
                self.contractorLabel.text = service.getContractor()
                self.serviceDateLabel.text = service.getDate()
                self.commentsLabel.text = service.getComments()
            }
        }
    }
    public var serviceIndex: Int?
    @IBOutlet weak var contractorLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
}
