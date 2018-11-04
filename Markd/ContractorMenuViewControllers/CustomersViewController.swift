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
    
    @IBOutlet var searchController: UISearchDisplayController!
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

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarIsEmpty() ? customersList.count : filteredCustomerList.count
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        return "Customers"
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView() //Removes seperators after list
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customerInformationCell", for: indexPath) as! CustomerInformationCell
        cell.customer = searchBarIsEmpty() ? customersList[indexPath.row] : filteredCustomerList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getCustomerData(with id:String) {
        Database.database().reference().child("users").child(id)
            .observeSingleEvent(of: .value, with: successListener, withCancel: errorListener)
    }
    //Mark: Firebase Event Listeners
    private func successListener(snapshot:DataSnapshot) {
        print("Got Customer")
        if let dictionary = snapshot.value as? [String : AnyObject] {
            customersList += [Customer(dictionary)]
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
    
    var customer:Customer? {
        didSet {
            if let customer = customer {
                configureView(with: customer)
            }
        }
    }

    private func configureView(with customer:Customer) {
        customerNameLabel.text = customer.getName()
        customerAddressLabel.text = customer.getAddress()?.toString()
    }
}
