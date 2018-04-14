//
//  HvacViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/7/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class HvacViewController: UIViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var customerData: TempCustomerData?
    
    @IBOutlet weak var hvacScrollView: UIScrollView!
    //Air Handler
    @IBOutlet weak var airHandlerManufacturer: UILabel!
    @IBOutlet weak var airHandlerModel: UILabel!
    @IBOutlet weak var airHandlerInstallDate: UILabel!
    @IBOutlet weak var airHandlerLifeSpan: UILabel!
    //Compressor
    @IBOutlet weak var compressorManufacturer: UILabel!
    @IBOutlet weak var compressorModel: UILabel!
    @IBOutlet weak var compressorInstallDate: UILabel!
    @IBOutlet weak var compressorLifeSpan: UILabel!
    
    var TODO_NotYetImplementedHvacPage:AnyObject?
    /*
     Check if Contractor or Home Owner on page
     Add Contractor to Footer
     Initialize Services
     Implement Edit Button
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
        if let hvacView = hvacScrollView {
            hvacView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
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
        initializeAirHandler()
        initializeCompressor()
    }
    private func initializeAirHandler() {
        if let airHandler = customerData?.getAirHandler() {
            if let airHandlerManufacturer = airHandlerManufacturer {
                airHandlerManufacturer.text = airHandler.getManufacturer()
            }
            if let airHandlerModel = airHandlerModel {
                airHandlerModel.text = airHandler.getModel()
            }
            if let airHandlerInstallDate = airHandlerInstallDate, let installDate = airHandler.installDateAsString() {
                airHandlerInstallDate.text = installDate
            }
            if let airHandlerLifeSpan = airHandlerLifeSpan {
                airHandlerLifeSpan.text = airHandler.lifeSpanAsString()
            }
        }
    }
    private func initializeCompressor() {
        if let compressor = customerData?.getCompressor() {
            if let compressorManufacturer = compressorManufacturer {
                compressorManufacturer.text = compressor.getManufacturer()
            }
            if let compressorModel = compressorModel {
                compressorModel.text = compressor.getModel()
            }
            if let compressorInstallDate = compressorInstallDate, let installDate = compressor.installDateAsString() {
                compressorInstallDate.text = installDate
            }
            if let compressorLifeSpan = compressorLifeSpan {
                compressorLifeSpan.text = compressor.lifeSpanAsString()
            }
        }
    }
    
    //Mark:- Segue
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHvacSegue" {
            let destination = segue.destination as! EditApplianceTableViewController
            destination.appliances = [customerData!.getAirHandler()!, customerData!.getCompressor()!]
            destination.viewTitle = "Edit Hvac"
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            destination.navigationItem.backBarButtonItem = backItem
            
            return
        }
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        var TODO_ChangeRootView🤪:AnyClass?
        let alert = UIAlertController(title: "Switch Page", message: "Which page would you like to switch to?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Plumbing", style: .default, handler: { _ in
            NSLog("Switching to Plumbing Page")
            if let navigationController = self.navigationController {
                let plumbingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlumbingViewController") as! PlumbingViewController
                navigationController.setViewControllers([plumbingViewController], animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Electrical", style: .default, handler: { _ in
            NSLog("Switching to Electrical Page")
        }))
        alert.addAction(UIAlertAction(title: "Painting", style: .default, handler: { _ in
            NSLog("Switching to Painting Page")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            NSLog("Cancels page switch")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("HvacViewController:- Got Customer Data")
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
    
}
