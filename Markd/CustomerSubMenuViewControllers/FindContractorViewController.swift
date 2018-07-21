//
//  FindContractorViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 7/20/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FindContractorViewController:UITableViewController, OnGetDataListener {
    private let zipCodeDatabase:DatabaseReference = Database.database().reference().child("zip_codes")
    private let authentication = FirebaseAuthentication.sharedInstance
    var customerData: TempCustomerData?
    public var selectedContractorType = "Plumber"
    var range = 30
    private var contractorReferences:[String] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(self.search))
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
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        }
        return contractorReferences.count
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Type"
        } else if section == 1 {
            return "Range"
        } else {
            return "Contractors"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = selectedContractorType
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rangeCell", for: indexPath) as! RangeTableViewCell
            cell.viewController = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "contractorCell", for: indexPath) as! ContractorTableViewCell
            cell.viewController = self
            cell.reference = contractorReferences[indexPath.row]
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            AlertControllerUtilities.showActionSheet(
                withTitle: "Contractor Type",
                andMessage: "What type of contractor are you searching for?",
                withOptions: [
                    UIAlertAction(title: "Plumber", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Hvac", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Electrician", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Painter", style: .default, handler: contractorTypeSelectionHandler),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ],
                in: self)
        } else if indexPath.section == 2 {
            let cell = tableView.cellForRow(at: indexPath) as! ContractorTableViewCell
            AlertControllerUtilities.showAlert(
                withTitle: "Confirm Change",
                andMessage: "Your new \(selectedContractorType) is \(cell.companyLabel.text!)?",
                withOptions: [
                    UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                        if let reference = cell.reference {
                            self.customerData!.updateContractor(of: self.selectedContractorType, to: reference)
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            AlertControllerUtilities.somethingWentWrong(with: self)
                        }
                    }),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ],
                in: self)
        }
    }
    func contractorTypeSelectionHandler(alert: UIAlertAction!) {
        if let contractorType = alert.title {
            selectedContractorType = contractorType
            tableView.reloadData()
        }
    }
    
    //Mark:- Helpers
    @objc func search() {
        print("Show \(selectedContractorType)s in \(range) miles from \(customerData!.getZipcode()!)")
        self.contractorReferences = []
        self.tableView.reloadData()
        ZipCodeUtilities.getZipCodes(in: range, from: customerData!.getZipcode()!, handler: getContractors)
    }

    private func getContractors(from zipcodes: [String]) {
        if zipcodes.isEmpty {
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
        zipCodeDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
            if let zipCodes = snapshot.value as? NSDictionary {
                for zipcode in zipcodes {
                    if let contractorDictionary = zipCodes[zipcode] as? NSDictionary {
                        self.filterContractors(from: contractorDictionary, with: self.selectedContractorType)
                    }
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
    }
    private func filterContractors(from dictionary: NSDictionary, with type: String) {
        for (reference, contractorType) in dictionary {
            if let reference = reference as? String, let contractorType = contractorType as? String {
                if contractorType == type {
                    self.contractorReferences.append(reference)
                }
            }
        }
    }
    //Mark:- OnGetDataListener
    public func onStart() {
        print("Getting Data")
    }
    
    public func onSuccess() {
        print("FindContractorViewController:- Got Customer Data")
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}

class RangeTableViewCell:UITableViewCell {
    var viewController: FindContractorViewController?
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var rangeStepper: UIStepper!
    
    @IBAction func onRangeValueChanged(_ sender: UIStepper) {
        let range = Int(round(sender.value))
        viewController!.range = range
        rangeLabel.text = "\(range) miles"
    }
}

class ContractorTableViewCell:UITableViewCell, OnGetContractorListener {
    let storage = Storage.storage()
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    @IBOutlet weak var websiteLabel: UIButton!
    @IBOutlet weak var companyLogo: UIImageView!
    
    func onFinished(contractor: Contractor?, at reference: String?) {
        if let contractor = contractor {
            configureView(with: contractor, at: reference)
        } else {
            AlertControllerUtilities.somethingWentWrong(with: viewController!)
        }
    }
    
    func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: viewController!)
    }
    
    var viewController: FindContractorViewController?
    var reference: String? {
        didSet {
            let contractorReference:DatabaseReference = TempCustomerData.getUserDatabase().child(self.reference!)
            contractorReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    self.onFinished(contractor: Contractor(dictionary), at: self.reference)
                }
            }) { (error) in
                self.onFailure(error)
            }
        }
    }
    private func configureView(with contractor: Contractor, at reference: String?) {
        if let companyLabel = companyLabel, let phoneNumberLabel = phoneNumberLabel, let websiteLabel = websiteLabel {
            if let contractorDetails = contractor.getContractorDetails() {
                companyLabel.text = contractorDetails.getCompanyName()
                let websiteUrl = contractorDetails.getWebsiteUrl()
                websiteLabel.setTitle(websiteUrl, for: .normal)
                if let phoneNumber = contractorDetails.getTelephoneNumber(){
                    phoneNumberLabel.setTitle(phoneNumber, for: .normal)
                }
            }
        }
        if let companyLogo = companyLogo {
            let placeholderImage = UIImage(named: "ic_action_pages")!
            companyLogo.kf.indicatorType = .activity
            if let reference = reference {
                let pathReference = storage.reference(withPath: "images/logos/\(reference)/\(contractor.getLogoFileName())")
                pathReference.downloadURL { url,error in
                    companyLogo.kf.setImage(with:url, placeholder:placeholderImage)
                }
            } else {
                companyLogo.kf.setImage(with: nil, placeholder: placeholderImage)
            }
        }
    }
}
