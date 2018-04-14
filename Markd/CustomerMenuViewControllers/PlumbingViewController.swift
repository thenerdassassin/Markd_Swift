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
    
    var TODO_NotYetImplementedPlumbingPage🤔:AnyObject?
    /*
     Check if Contractor or Home Owner on page
     Add Contractor to Footer
     Initialize Services
     */
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
        configureView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
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
                hotWaterManufacturer.text = hotWater.getManufacturer()
            }
            if let hotWaterModel = hotWaterModel {
                hotWaterModel.text = hotWater.getModel()
            }
            if let hotWaterInstallDate = hotWaterInstallDate, let installDate = hotWater.installDateAsString() {
                hotWaterInstallDate.text = installDate
            }
            if let hotWaterLifeSpan = hotWaterLifeSpan {
                hotWaterLifeSpan.text = hotWater.lifeSpanAsString()
            }
        }
    }
    private func initializeBoiler() {
        if let boiler = customerData?.getBoiler() {
            if let boilerManufacturer = boilerManufacturer {
                boilerManufacturer.text = boiler.getManufacturer()
            }
            if let boilerModel = boilerModel {
                boilerModel.text = boiler.getModel()
            }
            if let boilerInstallDate = boilerInstallDate, let installDate = boiler.installDateAsString() {
                boilerInstallDate.text = installDate
            }
            if let boilerLifeSpan = boilerLifeSpan {
                boilerLifeSpan.text = boiler.lifeSpanAsString()
            }
        }
    }
    
    //Mark:- Segue
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlumbingSegue" {
            let destination = segue.destination as! EditApplianceTableViewController
            destination.appliances = [customerData!.getHotWater()!, customerData!.getBoiler()!]
            destination.viewTitle = "Edit Plumbing"
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            return
        }
    }
    
    @IBAction func switchButtonAction(_ sender: UIBarButtonItem) {
        var TODO_ChangeRootViewToElectricalOrPainting🤪:AnyClass?
        AlertControllerUtilities.showActionSheet(
            withTitle: "Switch Page",
            andMessage: "Which page would you like to switch to?",
            withOptions: [
                UIAlertAction(title: "HVAC", style: .default, handler: { _ in
                    NSLog("Switching to HVAC Page")
                    if let navigationController = self.navigationController {
                        let hvacViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HvacViewController") as! HvacViewController
                        navigationController.setViewControllers([hvacViewController], animated: true)
                    }
                }),
                UIAlertAction(title: "Electrical", style: .default, handler: { _ in
                    NSLog("Switching to Electrical Page")
                }),UIAlertAction(title: "Painting", style: .default, handler: { _ in
                    NSLog("Switching to Painting Page")
                }),
                UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    NSLog("Canceling Edit")
                })
            ],
            in: self)
    }
    
    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Edit Page",
            andMessage: "Which appliance would you like to change?",
            withOptions: [
                UIAlertAction(title: "Domestic Hot Water", style: .default, handler: { _ in
                    NSLog("Editing Hot Water")
                    self.applianceToEdit = self.customerData?.getHotWater()
                    self.performSegue(withIdentifier: "editPlumbingSegue", sender: self)
                }),
                UIAlertAction(title: "Boiler", style: .default, handler: { _ in
                    NSLog("Editing Boiler")
                    self.applianceToEdit = self.customerData?.getBoiler()
                    self.performSegue(withIdentifier: "editPlumbingSegue", sender: self)
                }),
                UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    NSLog("Canceling Edit")
                })
            ],
            in: self)
    }
    
    //Mark:- OnGetDataListener Implementation
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("PlumbingViewController:- Got Customer Data")
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
    
}
