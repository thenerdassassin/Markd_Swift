//
//  PlumbingViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/4/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class PlumbingViewController: UIViewController, OnGetDataListener, ApplianceViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var applianceToEdit: Appliance?
    public var customerData: TempCustomerData?
    var isContractor: Bool = false
    
    var applianceTableViewController: ApplianceTableViewController?
    var plumberFooterViewController: OnGetContractorListener?
    
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
    
    // MARK: Segue
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plumbingTableSegue" {
            let destination = segue.destination as! ApplianceTableViewController
            self.applianceTableViewController = destination
            destination.customerData = customerData
            destination.delegate = self
            destination.sectionOneAppliances = customerData?.getBoiler()
            destination.sectionTwoAppliances = customerData?.getHotWater()
            return
        }
        if segue.identifier == "plumberFooterSegue" {
            let destination = segue.destination as! ContractorFooterViewController
            self.plumberFooterViewController = destination
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
            if sender.title == "Boiler" {
                destination.appliance = Boiler([:])
            } else {
                destination.appliance = HotWater([:])
            }
            
            customerData.removeListeners()
            destination.customerData = customerData
        }
    }
    
    // MARK: Navigation Buttons
    @IBAction func switchButtonAction(_ sender: UIBarButtonItem) {
        if isContractor {
            AlertControllerUtilities.showAlert(
                withTitle: "Disabled", andMessage: "As an painter, you may only edit this page.",
                withOptions: [UIAlertAction(title: "Ok", style: .default, handler: nil)], in: self)
        } else {
            AlertControllerUtilities.showActionSheet(
                withTitle: "Switch Page",
                andMessage: "Which page would you like to switch to?",
                withOptions: [
                    UIAlertAction(title: "HVAC", style: .default, handler: { _ in
                        NSLog("Switching to HVAC Page")
                        if let navigationController = self.navigationController {
                            let hvacViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "HvacViewController") as! HvacViewController
                            navigationController.setViewControllers([hvacViewController], animated: true)
                        }
                    }),
                    UIAlertAction(title: "Electrical", style: .default, handler: { _ in
                        NSLog("Switching to Electrical Page")
                        if let navigationController = self.navigationController {
                            let electricalViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "ElectricalViewController") as! ElectricalViewController
                            navigationController.setViewControllers([electricalViewController], animated: true)
                        }
                    }),UIAlertAction(title: "Painting", style: .default, handler: { _ in
                        NSLog("Switching to Painting Page")
                        if let navigationController = self.navigationController {
                            let paintingViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "PaintingViewController") as! PaintingViewController
                            navigationController.setViewControllers([paintingViewController], animated: true)
                        }
                    }),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        NSLog("Canceling Edit")
                    })
                ],
                in: self)
        }
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Add Appliance",
            andMessage: "What appliance would you like to add?",
            withOptions: [
                UIAlertAction(title: "Boiler", style: .default, handler: addApplianceHandler),
                UIAlertAction(title: "Hot Water", style: .default, handler: addApplianceHandler),
                UIAlertAction(title: "Cancel", style: .cancel)
            ],
            in: self)
    }
    func addApplianceHandler(alert: UIAlertAction!) {
        if alert.title != nil && alert.title != "Cancel" {
            self.performSegue(withIdentifier: "addApplianceSegue", sender: alert)
        }
    }
    // MARK:- GetData Protocols
    public func onStart() {
        print("Getting Data")
    }
    
    public func onSuccess() {
        print("PlumbingViewController:- Got Customer Data")
        customerData!.getPlumber(plumberListener: plumberFooterViewController)
        if let controller = applianceTableViewController {
            controller.customerData = customerData
            controller.sectionOneAppliances = customerData?.getBoiler()
            controller.sectionTwoAppliances = customerData?.getHotWater()
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}
