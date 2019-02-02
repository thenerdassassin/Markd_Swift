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

public class PlumbingViewController: UIViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var customerData: TempCustomerData?
    private var applianceToEdit: Appliance?
    var plumber: DataSnapshot?
    
    @IBOutlet weak var plumbingScrollView: UIScrollView!
    //Hot Water
    @IBOutlet weak var hotWaterManufacturer: UILabel!
    @IBOutlet weak var hotWaterModel: UILabel!
    @IBOutlet weak var hotWaterInstallDate: UILabel!
    @IBOutlet weak var hotWaterLifeSpan: UILabel!
    //Boiler
    @IBOutlet weak var boilerManufacturer: UILabel!
    @IBOutlet weak var boilerModel: UILabel!
    @IBOutlet weak var boilerInstallDate: UILabel!
    @IBOutlet weak var boilerLifeSpan: UILabel!
    
    var plumberFooterViewController: OnGetContractorListener?
    var TODO_NotYetImplementedPlumbingPage🤔:AnyObject?
    /*
     Check if Contractor or Home Owner on page
     */
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authentication.checkLogin(self) {
            customerData = TempCustomerData(self)
        }
        configureView()
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
        if let plumbingView = plumbingScrollView {
            plumbingView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    private func configureView() {
        initializeHotWater()
        initializeBoiler()
    }
    private func initializeHotWater() {
        if let hotWater = customerData?.getHotWater() {
            if let hotWaterManufacturer = hotWaterManufacturer {
                StringUtilities.set(textOf: hotWaterManufacturer, to: hotWater.getManufacturer())
            }
            if let hotWaterModel = hotWaterModel {
                StringUtilities.set(textOf: hotWaterModel, to: hotWater.getModel())
            }
            if let hotWaterInstallDate = hotWaterInstallDate {
                StringUtilities.set(textOf: hotWaterInstallDate, to: hotWater.installDateAsString())
            }
            if let hotWaterLifeSpan = hotWaterLifeSpan {
                StringUtilities.set(textOf: hotWaterLifeSpan, to: hotWater.lifeSpanAsString())
            }
        }
    }
    private func initializeBoiler() {
        if let boiler = customerData?.getBoiler() {
            if let boilerManufacturer = boilerManufacturer {
                StringUtilities.set(textOf: boilerManufacturer, to: boiler.getManufacturer())
            }
            if let boilerModel = boilerModel {
                StringUtilities.set(textOf: boilerModel, to: boiler.getModel())
            }
            if let boilerInstallDate = boilerInstallDate {
                StringUtilities.set(textOf: boilerInstallDate, to: boiler.installDateAsString())
            }
            if let boilerLifeSpan = boilerLifeSpan {
                StringUtilities.set(textOf: boilerLifeSpan, to: boiler.lifeSpanAsString())
            }
        }
    }
    
    //Mark:- Segue
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlumbingSegue" {
            let destination = segue.destination as! EditApplianceTableViewController
            var hotWater = customerData?.getHotWater()
            var boiler = customerData?.getBoiler()
            if (hotWater == nil) {
                hotWater = HotWater(Dictionary.init())
            }
            if (boiler == nil) {
                boiler = Boiler(Dictionary.init())
            }
            destination.appliances = [hotWater!, boiler!]
            destination.viewTitle = "Edit Plumbing"
            destination.customerData = customerData
            return
        }
        if segue.identifier == "plumberFooterSegue" {
            let destination = segue.destination as! ContractorFooterViewController
            self.plumberFooterViewController = destination
            return
        }
    }
    
    @IBAction func switchButtonAction(_ sender: UIBarButtonItem) {
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
    
    //Mark:- GetData Protocols
    public func onStart() {
        print("Getting Data")
    }
    
    public func onSuccess() {
        print("PlumbingViewController:- Got Customer Data")
        configureView()
        customerData!.getPlumber(plumberListener: plumberFooterViewController)
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}
