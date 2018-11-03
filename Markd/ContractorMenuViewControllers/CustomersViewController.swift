//
//  CustomersViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 11/3/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase

class CustomersViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var contractorData:TempContractorData?

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
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
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = contractorData?.getCustomers()?.count
        return count != nil ? count! : 0
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        return "Customers"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerInformationCell", for: indexPath) as! CustomerInformationCell
        cell.viewController = self
        cell.customerId = contractorData?.getCustomers()?[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Contractor Data")
    }
    
    public func onSuccess() {
        print("CustomersViewController:- Got Contractor Data")
        self.tableView.reloadData()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}

class CustomerInformationCell: UITableViewCell {
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerAddressLabel: UILabel!
    
    var viewController:CustomersViewController?
    var customerId:String? {
        didSet {
            if let customerId = customerId {
                getCustomerData(with: customerId)
            }
        }
    }
    var customer:Customer? {
        didSet {
            if let customer = customer {
                configureView(with: customer)
            }
        }
    }
    
    private func getCustomerData(with id:String) {
        Database.database().reference().child("users").child(id)
                .observeSingleEvent(of: .value, with: successListener, withCancel: errorListener)
    }
    private func configureView(with customer:Customer) {
        customerNameLabel.text = customer.getName()
        customerAddressLabel.text = customer.getAddress()?.toString()
    }
    
    //Mark: Firebase Event Listeners
    private func successListener(snapshot:DataSnapshot) {
        if let dictionary = snapshot.value as? [String : AnyObject] {
            self.customer = Customer(dictionary)
        } else {
            AlertControllerUtilities.somethingWentWrong(with: viewController!, because: MarkdError.UnexpectedNil)
        }
    }
    private func errorListener(error:Error) {
        AlertControllerUtilities.somethingWentWrong(with: viewController!, because: error)
    }
}
