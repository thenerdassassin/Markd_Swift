//
//  ServiceHistoryTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/27/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ServiceHistoryViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData?
    let cellIdentifier = "serviceCell"
    var plumbingServices:[ContractorService]?
    var hvacServices:[ContractorService]?
    var electricalServices:[ContractorService]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
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
    
    @IBAction func onAddServiceAction(_ sender: UIBarButtonItem) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Add Service",
            andMessage: "What service type is being added?",
            withOptions: [
                UIAlertAction(title: "Plumbing", style: .default, handler: addServiceHandler),
                UIAlertAction(title: "Hvac", style: .default, handler: addServiceHandler),
                UIAlertAction(title: "Electrical", style: .default, handler: addServiceHandler),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ],
            in: self
        )
    }
    func addServiceHandler(alert: UIAlertAction!) {
        if alert.title != nil && alert.title != "Cancel" {
            self.performSegue(withIdentifier: "addContractorServiceSegue", sender: alert)
        }
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
            destination.serviceType = getTypeFromTag(sender.tag)
            destination.serviceIndex = sender.serviceIndex
            destination.service = service
        } else if segue.identifier == "addContractorServiceSegue" {
            let sender = sender as! UIAlertAction
            let destination = segue.destination as! ContractorServiceTableViewController
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            destination.serviceType = sender.title
            destination.serviceIndex = -1
            let newService = ContractorService()
            newService.setGuid(nil)
            destination.service = newService
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
                StringUtilities.set(textOf: self.contractorLabel, to: service.getContractor())
                StringUtilities.set(textOf: self.serviceDateLabel, to: service.getDate())
                self.commentsLabel.text = service.getComments()
            }
        }
    }
    public var serviceIndex: Int?
    @IBOutlet weak var contractorLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
}
