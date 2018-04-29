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
    
    var TODO_add_Markd_Header🙌🏻:AnyObject?
    
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
            //Plumbing
            if let plumbingServices = plumbingServices {
                return plumbingServices.count
            }
        } else if section == 1 {
            //Hvac
            if let hvacServices = hvacServices {
                return hvacServices.count
            }
        } else if section == 2 {
            //Electrical
            if let electricalServices = electricalServices {
                return electricalServices.count
            }
        }
        return 0
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
        if indexPath.section == 0 {
            service = plumbingServices?[indexPath.row]
        } else if indexPath.section == 1 {
            service = hvacServices?[indexPath.row]
        } else if indexPath.section == 2 {
            service = electricalServices?[indexPath.row]
        }
        // TODO: Configure the cell...
        if let service = service {
            serviceCell.contractorLabel.text = service.getContractor()
            serviceCell.serviceDateLabel.text = service.getDate()
            serviceCell.commentsLabel.text = service.getComments()
        }
        
        return serviceCell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContractorServiceSegue" {
            //let destination = segue.destination as! ContractorServiceTableViewController
            var TODO_PassInfoInSegue_😳:AnyObject?
        }
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
    @IBOutlet weak var contractorLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
}
