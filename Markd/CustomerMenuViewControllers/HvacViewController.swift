//
//  HvacViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/7/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class HvacViewController: UIViewController, OnGetDataListener, ApplianceViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var applianceToEdit: Appliance?
    public var customerData: TempCustomerData?
    var isContractor: Bool = false
    
    var applianceTableViewController: ApplianceTableViewController?
    var hvacTechnicianFooterViewController: OnGetContractorListener?
    
    // MARK: View Lifecycle
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authentication.checkLogin(self) {
            if(!isContractor) {
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
    override public func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    //Mark:- Segue
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hvacTableSegue" {
            let destination = segue.destination as! ApplianceTableViewController
            self.applianceTableViewController = destination
            destination.isPlumbing = false
            destination.customerData = customerData
            destination.delegate = self
            destination.sectionOneAppliances = customerData?.getCompressor()
            destination.sectionTwoAppliances = customerData?.getAirHandler()
            return
        }
        if segue.identifier == "hvacFooterSegue" {
            let destination = segue.destination as! ContractorFooterViewController
            self.hvacTechnicianFooterViewController = destination
            return
        }
        if segue.identifier == "addApplianceSegue" {
            let sender = sender as! UIAlertAction
            let destination = segue.destination as! EditApplianceTableViewController
            destination.delegate = self
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            
            destination.index = -1
            if sender.title == "Compressor" {
                destination.appliance = Compressor([:])
            } else {
                destination.appliance = AirHandler([:])
            }
            
            customerData.removeListeners()
            destination.customerData = customerData
        }
    }
    
    // MARK: Navigation Buttons
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Switch Page", message: "Which page would you like to switch to?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Plumbing", style: .default, handler: { _ in
            NSLog("Switching to Plumbing Page")
            if let navigationController = self.navigationController {
                let plumbingViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "PlumbingViewController") as! PlumbingViewController
                navigationController.setViewControllers([plumbingViewController], animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Electrical", style: .default, handler: { _ in
            NSLog("Switching to Electrical Page")
            if let navigationController = self.navigationController {
                let electricalViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "ElectricalViewController") as! ElectricalViewController
                navigationController.setViewControllers([electricalViewController], animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Painting", style: .default, handler: { _ in
            NSLog("Switching to Painting Page")
            if let navigationController = self.navigationController {
                let paintingViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "PaintingViewController") as! PaintingViewController
                navigationController.setViewControllers([paintingViewController], animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            NSLog("Cancel page switch")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Add Appliance",
            andMessage: "What appliance would you like to add?",
            withOptions: [
                UIAlertAction(title: "Compressor", style: .default, handler: addApplianceHandler),
                UIAlertAction(title: "Air Handler", style: .default, handler: addApplianceHandler),
                UIAlertAction(title: "Cancel", style: .cancel)
            ],
            in: self)
    }
    func addApplianceHandler(alert: UIAlertAction!) {
        if alert.title != nil && alert.title != "Cancel" {
            self.performSegue(withIdentifier: "addApplianceSegue", sender: alert)
        }
    }
    
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("HvacViewController:- Got Customer Data")
        customerData!.getHvacTechnician(hvacTechnicianListener: hvacTechnicianFooterViewController)
        if let controller = applianceTableViewController {
            controller.customerData = customerData
            controller.sectionOneAppliances = customerData?.getCompressor()
            controller.sectionTwoAppliances = customerData?.getAirHandler()
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}
