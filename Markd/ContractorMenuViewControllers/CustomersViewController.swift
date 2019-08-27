//
//  CustomersViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 11/3/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase

class CustomersViewController: UITableViewController, UISearchBarDelegate, OnGetDataListener, PurchaseHandler {
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
    
    private func isSubscribed() -> Bool {
        // Give them three days to renew subscription otherwise show purchase alert
        return contractorData?.getSubscriptionExpirationDate() != nil && Calendar.current.date(byAdding: .day, value: 3, to: Date())! < contractorData!.getSubscriptionExpirationDate()!
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
        } else if segue.identifier == "showPlumbingDetailsSegue" {
            if let customer = sender as? Customer {
                let destination = segue.destination as! EditApplianceTableViewController
                if let id = customer.customerId {
                    let hotWater = customer.getHotWater() != nil ? customer.getHotWater()! : HotWater([:])
                    let boiler = customer.getBoiler() != nil ? customer.getBoiler()! : Boiler([:])
                    destination.customerData = TempCustomerData(nil, at: id)
                    destination.appliances = [hotWater, boiler]
                    destination.viewTitle = "Edit Plumbing"
                } else {
                    AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                }
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
            }
        } else if segue.identifier == "showHvacDetailsSegue" {
            if let customer = sender as? Customer {
                let destination = segue.destination as! EditApplianceTableViewController
                if let id = customer.customerId {
                    let airHandler = customer.getAirHandler() != nil ? customer.getAirHandler()! : AirHandler([:])
                    let compressor = customer.getCompressor() != nil ? customer.getCompressor()! : Compressor([:])
                    destination.customerData = TempCustomerData(nil, at: id)
                    destination.appliances = [airHandler, compressor]
                    destination.viewTitle = "Edit Hvac"
                } else {
                    AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                }
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
            }
        } else if segue.identifier == "showElectricalDetailsSegue" {
            if let customer = sender as? Customer {
                let destination = segue.destination as! ElectricalViewController
                if let id = customer.customerId {
                    destination.customerData = TempCustomerData(destination, at: id)
                    destination.isContractor = true
                } else {
                    AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                }
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
            }
        } else if segue.identifier == "showPaintingDetailsSegue" {
            if let customer = sender as? Customer {
                let destination = segue.destination as! PaintingViewController
                if let id = customer.customerId {
                    destination.customerData = TempCustomerData(destination, at: id)
                    destination.isContractor = true
                } else {
                    AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                }
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
            }
        } else if segue.identifier == "editServiceHistorySegue" {
            let contractorType = self.contractorData!.getContractorType()
            let customer = sender as! Customer
            let serviceViewController = segue.destination as! ServiceHistoryViewController
            let id = customer.customerId!
            serviceViewController.customerData = TempCustomerData(serviceViewController, at: id)
            serviceViewController.contractorType = contractorType!
        }
    }

    //MARK:- Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        }
        let customerCount = searchBarIsEmpty() ? customersList.count : filteredCustomerList.count
        return customerCount == 0 ? 1 : customerCount
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
            
            if isSubscribed() {
                cell.textLabel?.text = "Message All Customers"
            } else {
                cell.textLabel?.text = "Subscribe"
            }
            return cell
        } else if indexPath.section == 1 {
            let customerCount = searchBarIsEmpty() ? customersList.count : filteredCustomerList.count
            if customerCount != 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "customerInformationCell", for: indexPath) as! CustomerInformationCell
                cell.customer = searchBarIsEmpty() ? customersList[indexPath.row] : filteredCustomerList[indexPath.row]
                return cell
            }
        }
        return self.tableView.dequeueReusableCell(withIdentifier: "noCustomersCell", for: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            guard isSubscribed() else {
                AlertControllerUtilities.showPurchaseAlert(in: self)
                return
            }
            performSegue(withIdentifier: "sendNotificationToCustomerSegue", sender: selectedCell)
        } else {
            let customerCount = searchBarIsEmpty() ? customersList.count : filteredCustomerList.count
            if customerCount != 0 {
                AlertControllerUtilities.showActionSheet(
                    withTitle: "Select Action 🔨", andMessage: "What would you like to do for your customer?",
                    withOptions: [
                        UIAlertAction(title: "Send Notification", style: .default, handler: { _ in
                            guard self.isSubscribed() else {
                                AlertControllerUtilities.showPurchaseAlert(in: self)
                                return
                            }
                            self.performSegue(withIdentifier: "sendNotificationToCustomerSegue", sender: selectedCell)
                            
                        }),
                        UIAlertAction(title: "Edit Home Details", style: .default, handler: { _ in
                            self.editHomeDetails(
                                of: self.contractorData?.getContractorType(),
                                for: (selectedCell as? CustomerInformationCell)?.customer)
                        }),
                        UIAlertAction(title: "Edit Service History", style: .default, handler: { _ in
                            self.editServiceHistory(
                                of: self.contractorData?.getContractorType(),
                                for: (selectedCell as? CustomerInformationCell)?.customer)
                        }),
                        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    ],
                    in: self)
            }
        }
    }
    
    //Mark:- Select Table Row Actions
    private func editHomeDetails(of type:String?, for customer: Customer?) {
        guard let contractorType = type else {
            print("Type is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        guard let customer = customer else {
            print("Customer Data is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        guard isSubscribed() else {
            AlertControllerUtilities.showPurchaseAlert(in: self)
            return
        }
        
        switch contractorType {
        case "Plumber":
            print("Edit Plumbing Page of \(customer.customerId ?? "NIL")")
            performSegue(withIdentifier: "showPlumbingDetailsSegue", sender: customer)
        case "Hvac":
            print("Edit Hvac Page of \(customer.customerId ?? "NIL")")
            performSegue(withIdentifier: "showHvacDetailsSegue", sender: customer)
        case "Electrician":
            print("Edit Electrician Page of \(customer.customerId ?? "NIL")")
            performSegue(withIdentifier: "showElectricalDetailsSegue", sender: customer)
        case "Painter":
            print("Edit Painter Page of \(customer.customerId ?? "NIL")")
            performSegue(withIdentifier: "showPaintingDetailsSegue", sender: customer)
        default:
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
    }
    
    private func editServiceHistory(of type:String?, for customer: Customer?) {
        guard let contractorType = type else {
            print("Type is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        guard let customer = customer else {
            print("Customer is nil")
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        guard isSubscribed() else {
            AlertControllerUtilities.showPurchaseAlert(in: self)
            return
        }
        
        switch contractorType {
        case "Plumber":
            print("Edit Plumbing Service of \(customer.customerId ?? "NIL")")
        case "Hvac":
            print("Edit Hvac Service of \(customer.customerId ?? "NIL")")
        case "Electrician":
            print("Edit Electrical Service of \(customer.customerId ?? "NIL")")
        case "Painter":
            print("Edit Painting Service of \(customer.customerId ?? "NIL")")
        default:
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
        performSegue(withIdentifier: "editServiceHistorySegue", sender: customer)
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
        
        guard isSubscribed() else {
            AlertControllerUtilities.showPurchaseAlert(in: self)
            return
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
    
    //Mark:- PurchaseHandler Implementation
    public func purchase(_ action: UIAlertAction) {
        //Prevent message from being shown every time by setting subscription expiration to the past
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        contractorData?.setSubscriptionExpiration(to: oneDayAgo)
        if action.title == "Subscribe" {
            //The Observer will set the expiration date to the future if purchase is successful
            InAppPurchasesObserver.instance.purchase(self)
        }
    }
    
    public func purchase(wasSuccessful: Bool) {
        if wasSuccessful {
            let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: Date())
            contractorData?.setSubscriptionExpiration(to: oneYearFromNow)
        } else {
            let fourDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: Date())
            contractorData?.setSubscriptionExpiration(to: fourDaysAgo)
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
