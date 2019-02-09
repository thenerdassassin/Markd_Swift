//
//  CustomersViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 11/3/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase

class CustomersViewController: UITableViewController, UISearchBarDelegate, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var contractorData:TempContractorData?
    
    @IBOutlet var searchController: UISearchController!
    @IBOutlet weak var searchBar: UISearchBar!
    var customersList:[Customer] = [] {
        didSet {
            customersList.sort(by: { $0.getLastName() < $1.getLastName()})
            tableView.reloadData()
        }
    }
    var filteredCustomerList:[Customer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        self.definesPresentationContext = true
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            contractorData = TempContractorData(self)
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
        if let contractorData = contractorData {
            contractorData.removeListeners()
        }
        searchController.isActive = false
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendNotificationToCustomerSegue" {
            if let sender = sender as? CustomerInformationCell {
                let destination = segue.destination as! SendNotificationViewController
                destination.customer = sender.customer
                destination.customerId = sender.customer?.customerId
                destination.companyName = contractorData?.getContractorDetails()?.getCompanyName()
            } else {
                let destination = segue.destination as! SendNotificationViewController
                destination.companyName = contractorData?.getContractorDetails()?.getCompanyName()
                destination.customerList = customersList
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        }
        return searchBarIsEmpty() ? customersList.count : filteredCustomerList.count
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if section == 1 {
            return "Customers"
        }
        return ""
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 28.0;
        }
        else {
            // One table view style will not allow 0 value for some reason
            return 0.00001;
        }
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
           return UIView() //Removes seperators after list
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Message All Customers"
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customerInformationCell", for: indexPath) as! CustomerInformationCell
        cell.customer = searchBarIsEmpty() ? customersList[indexPath.row] : filteredCustomerList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            performSegue(withIdentifier: "sendNotificationToCustomerSegue", sender: selectedCell)
        } else {
            AlertControllerUtilities.showActionSheet(
                withTitle: "Select Action 🔨", andMessage: "What would you like to do for your customer?",
                withOptions: [
                    UIAlertAction(title: "Send Notification", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "sendNotificationToCustomerSegue", sender: selectedCell)
                        
                    }),
                    UIAlertAction(title: "Edit Home Details", style: .default, handler: { _ in
                        self.editHomeDetails(
                            of: self.contractorData?.getContractorType(),
                            for: (selectedCell as? CustomerInformationCell)?.customerId)
                    }),
                    UIAlertAction(title: "Edit Service History", style: .default, handler: { _ in
                        self.editServiceHistory(
                            of: self.contractorData?.getContractorType(),
                            for: (selectedCell as? CustomerInformationCell)?.customerId)
                    }),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ],
                in: self)
        }
    }
    
    private func editHomeDetails(of type:String?, for customerId: String?) {
        guard let contractorType = type else {
            print("Type is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        guard let customerId = customerId else {
            print("Customer Id is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        
        switch contractorType {
        case "Plumber":
            print("Edit Plumbing Page of \(customerId)")
        case "Hvac":
            print("Edit Hvac Page of \(customerId)")
        case "Electrician":
            print("Edit Electrical Page of \(customerId)")
        case "Painter":
            print("Edit Painting Page of \(customerId)")
        default:
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
    }
    
    private func editServiceHistory(of type:String?, for customerId: String?) {
        guard let contractorType = type else {
            print("Type is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        guard let customerId = customerId else {
            print("Customer Id is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        
        switch contractorType {
        case "Plumber":
            print("Edit Plumbing Service of \(customerId)")
        case "Hvac":
            print("Edit Hvac Service of \(customerId)")
        case "Electrician":
            print("Edit Electrical Service of \(customerId)")
        case "Painter":
            print("Edit Painting Service of \(customerId)")
        default:
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
    }
    
    private func getCustomerData(with id:String) {
        Database.database().reference().child("users").child(id)
            .observeSingleEvent(of: .value, with: successListener, withCancel: errorListener)
    }
    
    //Mark: Firebase Event Listeners
    private func successListener(snapshot:DataSnapshot) {
        if let dictionary = snapshot.value as? [String : AnyObject] {
            customersList += [Customer(dictionary, customerId: snapshot.key)]
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
        }
    }
    private func errorListener(error:Error) {
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
    
    // Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Contractor Data")
    }
    
    public func onSuccess() {
        print("CustomersViewController:- Got Contractor Data")
        customersList = []
        filteredCustomerList = []
        if let customerIdList = contractorData?.getCustomers() {
            for contractorId in customerIdList {
                getCustomerData(with: contractorId)
            }
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
    
    // Mark:- UISearchBarDelegate
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let searchText = searchBar.text != nil ? searchBar.text! : ""
        customerList(filterOn: selectedScope, contains: searchText)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customerList(filterOn: searchBar.selectedScopeButtonIndex, contains: searchText)
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    private func customerList(filterOn scopeIndex: Int, contains string: String) {
        if scopeIndex == 0 {
            filteredCustomerList =  customersList.filter({(customer: Customer) -> Bool in
                return customer.getName().range(of: string, options: .caseInsensitive) != nil
            }).sorted(by: {$0.getLastName() < $1.getLastName()})
        } else {
            filteredCustomerList = customersList.filter({(customer: Customer) -> Bool in
                return customer.getAddress()?.toString().range(of: string, options: .caseInsensitive) != nil
            }).sorted(by: {$0.getLastName() < $1.getLastName()})
        }
    }
}

class CustomerInformationCell: UITableViewCell {
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerAddressLabel: UILabel!
    
    var customerId:String?
    var customer:Customer? {
        didSet {
            if let customer = customer {
                configureView(with: customer)
            }
        }
    }

    private func configureView(with customer:Customer) {
        customerId = customer.customerId
        customerNameLabel.text = customer.getName()
        customerAddressLabel.text = customer.getAddress()?.toString()
    }
}
