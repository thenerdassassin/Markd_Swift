//
//  ElectricalViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/5/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ElectricalViewController: UIViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData?
    
    var electricalPanelsViewController: ElectricalPanelsViewController?
    var electricalFooterViewController: OnGetContractorListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewControllerUtilities.insertMarkdLogo(into: self)
        if authentication.checkLogin(self) {
            customerData = TempCustomerData(self)
        }
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    // MARK: - Navigation
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "electricalPanelsSegue" {
            let destination = segue.destination as! ElectricalPanelsViewController
            self.electricalPanelsViewController = destination
            destination.customerData = customerData
            return
        }
        if segue.identifier == "electricianFooterSegue" {
            let destination = segue.destination as! ContractorFooterViewController
            self.electricalFooterViewController = destination
            return
        }
        if segue.identifier == "addPanelSegue" {
            let destination = segue.destination as! EditPanelViewController
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            destination.panel = Panel()
            destination.panelIndex = -1
            return
        }
    }
    
    @IBAction func switchButtonAction(_ sender: UIBarButtonItem) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Switch Page",
            andMessage: "Which page would you like to switch to?",
            withOptions: [
                UIAlertAction(title: "Plumbing", style: .default, handler: { _ in
                    NSLog("Switching to Plumbing Page")
                    if let navigationController = self.navigationController {
                        let plumbingViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "PlumbingViewController") as! PlumbingViewController
                        navigationController.setViewControllers([plumbingViewController], animated: true)
                    }
                }),
                UIAlertAction(title: "HVAC", style: .default, handler: { _ in
                    NSLog("Switching to HVAC Page")
                    if let navigationController = self.navigationController {
                        let hvacViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "HvacViewController") as! HvacViewController
                        navigationController.setViewControllers([hvacViewController], animated: true)
                    }
                }),
                UIAlertAction(title: "Painting", style: .default, handler: { _ in
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
    
    //Mark: OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("ElectricalViewController:- Got Customer Data")
        customerData!.getElectrician(electricianListener: electricalFooterViewController)
        if let controller = electricalPanelsViewController {
            controller.customerData = customerData
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
