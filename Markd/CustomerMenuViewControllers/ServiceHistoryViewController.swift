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
    public var customerData:TempCustomerData? {
        didSet {
            self.onSuccess()
        }
    }
    let cellIdentifier = "serviceCell"
    var plumbingServices:[ContractorService]?
    var hvacServices:[ContractorService]?
    var electricalServices:[ContractorService]?
    var contractorServices:[ContractorService]?
    var contractorType:String = "" {
        didSet {
            setContractorServices(to: contractorType)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            if StringUtilities.isNilOrEmpty(contractorType) {
                customerData = TempCustomerData(self)
            }
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
        if contractorServices != nil {
            return 1
        }
        return 3 // Plumbing, Hvac, Electrical
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let contractorServices = contractorServices {
                if contractorServices.count != 0 {
                    return contractorServices.count
                }
            } else if let plumbingServices = plumbingServices {
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
        if contractorServices != nil {
            return "Service History"
        }
        if section == 0 {
            return "Plumbing Service History"
        } else if section == 1 {
            return "Hvac Service History"
        } else if section == 2 {
            return "Electrical Service History"
        } else {
            return "Service History"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceCell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! ServiceTableViewCell
        var service:ContractorService?
        serviceCell.tag = indexPath.section
        serviceCell.serviceIndex = indexPath.row
        
        if indexPath.section == 0 {
            if contractorServices == nil {
                if plumbingServices != nil && plumbingServices!.count > 0 {
                    service = plumbingServices?[indexPath.row]
                }
            } else if contractorServices!.count != 0 {
                service = contractorServices?[indexPath.row]
            }
        } else if indexPath.section == 1 {
            if hvacServices != nil && hvacServices!.count > 0 {
                service = hvacServices?[indexPath.row]
            }
        } else if indexPath.section == 2 {
            if electricalServices != nil && electricalServices!.count > 0 {
                service = electricalServices?[indexPath.row]
            }
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
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
        var options:[UIAlertAction] = []
        if contractorServices != nil {
            options = [UIAlertAction(title: "Add Service", style: .default, handler: addServiceHandler),
                       UIAlertAction(title: "Cancel", style: .cancel, handler: nil)]
        } else {
            options = [
                UIAlertAction(title: "Plumbing", style: .default, handler: addServiceHandler),
                UIAlertAction(title: "Hvac", style: .default, handler: addServiceHandler),
                UIAlertAction(title: "Electrical", style: .default, handler: addServiceHandler),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ]
        }
        AlertControllerUtilities.showActionSheet(
            withTitle: "Add Service",
            andMessage: "What service type is being added?",
            withOptions: options,
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
        if(tableView.cellForRow(at: indexPath)?.reuseIdentifier == "serviceDefaultCell") {
            return false
        }
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            if contractorServices != nil {
                print("TODO: delete when contractorService")
                return
            }
            tableView.beginUpdates()
            // Delete the row from the data source
            if indexPath.section == 0 {
                plumbingServices!.remove(at: indexPath.row)
                let _ = customerData.removeService(indexPath.row, of: "Plumbing")
                if(plumbingServices!.count == 0) {
                    tableView.reloadSections([0], with: .fade)
                    tableView.endUpdates()
                    return
                }
            } else if indexPath.section == 1 {
                hvacServices!.remove(at: indexPath.row)
                let _ = customerData.removeService(indexPath.row, of: "Hvac")
                if(hvacServices!.count == 0) {
                    tableView.reloadSections([1], with: .fade)
                    tableView.endUpdates()
                    return
                }
            } else if indexPath.section == 2 {
                electricalServices!.remove(at: indexPath.row)
                let _ = customerData.removeService(indexPath.row, of: "Electrical")
                if(electricalServices!.count == 0) {
                    tableView.reloadSections([2], with: .fade)
                    tableView.endUpdates()
                    return
                }
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
                return
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContractorServiceSegue" {
            let sender = sender as! ServiceTableViewCell
            let destination = segue.destination as! ContractorServiceTableViewController
            guard let customerData = customerData, let service = sender.service else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            destination.delegate = self
            if contractorServices != nil {
                destination.serviceType = contractorType
            } else {
                destination.serviceType = getTypeFromTag(sender.tag)
            }
            destination.serviceIndex = sender.serviceIndex
            destination.service = service
        } else if segue.identifier == "addContractorServiceSegue" {
            let sender = sender as! UIAlertAction
            let destination = segue.destination as! ContractorServiceTableViewController
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            if sender.title == "Add Service" {
                destination.serviceType = contractorType
            } else {
                destination.serviceType = sender.title
            }
            destination.serviceIndex = -1
            let newService = ContractorService()
            newService.setGuid(nil)
            destination.service = newService
            destination.delegate = self
        }
    }
    private func setContractorServices(to type:String) {
        if StringUtilities.isNilOrEmpty(type) {
            contractorServices = nil
            return
        }
        switch type {
        case "Plumber":
            if plumbingServices != nil {
                contractorServices = plumbingServices
            } else {
                contractorServices = []
            }
        case "Hvac":
            if hvacServices != nil {
                contractorServices = hvacServices
            } else {
                contractorServices = []
            }
        case "Electrician":
            if electricalServices != nil {
                contractorServices = electricalServices
            } else {
                contractorServices = []
            }
        default:
            contractorServices = []
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
        setContractorServices(to: contractorType)
        self.tableView.reloadData()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
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
