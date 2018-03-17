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
    @IBOutlet weak var hotWaterManufacturer: UILabel!
    @IBOutlet weak var hotWaterModel: UILabel!
    @IBOutlet weak var hotWaterInstallDate: UILabel!
    @IBOutlet weak var hotWaterLifeSpan: UILabel!
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if let plumbingView = plumbingScrollView {
            plumbingView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        }
        configureView()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    func configureView() {
        if let customerData = customerData {
            if let hotWaterManufacturer = hotWaterManufacturer, let hotWaterModel = hotWaterModel, let hotWaterInstallDate = hotWaterInstallDate, let hotWaterLifeSpan = hotWaterLifeSpan {
                var TODO_SetTextInViews🤪:AnyClass?
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
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
    
}
