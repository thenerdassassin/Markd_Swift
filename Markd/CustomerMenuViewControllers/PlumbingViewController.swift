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
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    func configureView() {
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
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        var TODO_ChangeRootView🤪:AnyClass?
        
        let alert = UIAlertController(title: "Switch Page", message: "Which page would you like to switch to?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "HVAC", style: .default, handler: { _ in
            NSLog("Switching to HVAC Page")
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
