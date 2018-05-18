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
    
    var hvacTechnicianFooterViewController: OnGetContractorListener?
    var TODO_NotYetImplementedHvacPage:AnyObject?
    /*
     Check if Contractor or Home Owner on page
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
                StringUtilities.set(textOf: airHandlerManufacturer, to: airHandler.getManufacturer())
            }
            if let airHandlerModel = airHandlerModel {
                StringUtilities.set(textOf: airHandlerModel, to: airHandler.getModel())
            }
            if let airHandlerInstallDate = airHandlerInstallDate {
                StringUtilities.set(textOf: airHandlerInstallDate, to: airHandler.installDateAsString())
            }
            if let airHandlerLifeSpan = airHandlerLifeSpan {
                StringUtilities.set(textOf: airHandlerLifeSpan, to: airHandler.lifeSpanAsString())
            }
        }
    }
    private func initializeCompressor() {
        if let compressor = customerData?.getCompressor() {
            if let compressorManufacturer = compressorManufacturer {
                StringUtilities.set(textOf: compressorManufacturer, to: compressor.getManufacturer())
            }
            if let compressorModel = compressorModel {
                StringUtilities.set(textOf: compressorModel, to: compressor.getModel())
            }
            if let compressorInstallDate = compressorInstallDate {
                StringUtilities.set(textOf: compressorInstallDate, to: compressor.installDateAsString())
            }
            if let compressorLifeSpan = compressorLifeSpan {
                StringUtilities.set(textOf: compressorLifeSpan, to: compressor.lifeSpanAsString())
            }
        }
    }
    
    //Mark:- Segue
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHvacSegue" {
            let destination = segue.destination as! EditApplianceTableViewController
            var airHandler = customerData?.getAirHandler()
            var compressor = customerData?.getCompressor()
            if(airHandler == nil) {
                airHandler = AirHandler(Dictionary.init())
            }
            if (compressor == nil) {
                compressor = Compressor(Dictionary.init())
            }
            destination.appliances = [airHandler!, compressor!]
            destination.viewTitle = "Edit Hvac"
            destination.customerData = customerData
            return
        }
        if segue.identifier == "hvacFooterSegue" {
            let destination = segue.destination as! ContractorFooterViewController
            self.hvacTechnicianFooterViewController = destination
            return
        }
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        var TODO_ChangeRootView🤪:AnyClass?
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
        customerData!.getHvacTechnician(hvacTechnicianListener: hvacTechnicianFooterViewController)
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
