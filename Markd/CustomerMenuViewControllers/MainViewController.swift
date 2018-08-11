//
//  MainViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class MainViewController: UIViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var customerData: TempCustomerData?
    
    @IBOutlet weak var preparedForLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var homeInformationLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authentication.checkLogin(self) {
            customerData = TempCustomerData(self)
            var TODO_SetUpActionBar_🤪: AnyObject?
            var TODO_CameraHomeImageCapture_🤪: AnyObject?
            var TODO_HomeImageClickListeners_🤪: AnyObject?
            var TODO_LoadImage_🤪: AnyObject?
            var TODO_RealtorBuilderAndArchitect_🤪: AnyObject?
            var TODO_ContactRealtorEtcAlertAction_🤪: AnyObject?
        }
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
        configureView()
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false;
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    func configureView() {
        if let customerData = customerData, let preparedForLabel = preparedForLabel, let streetAddressLabel = streetAddressLabel, let homeInformationLabel = homeInformationLabel {
            preparedForLabel.text = "Prepared for \(customerData.getName())"
            if let streetAddress = customerData.getFormattedAddress(), let roomInformation = customerData.getRoomInformation(), let squareFootage = customerData.getSquareFootageString() {
                streetAddressLabel.text = "\(streetAddress)"
                homeInformationLabel.text = "\(roomInformation) \n\(squareFootage)"
            } else {
                AlertControllerUtilities.showAlert(withTitle: "Welcome to Markd 😃", andMessage: "First, let's get some info about your home.", withOptions: [UIAlertAction(title: "Ok", style: .default, handler: addHomeInformation)], in: self)
                streetAddressLabel.text = "Loading...."
                homeInformationLabel.text = "-- bathrooms -- bedrooms \n -- square feet"
            }
        }
    }
    
    private func addHomeInformation(_ action:UIAlertAction) {
        print("Go to EditHomeVC")
        performSegue(withIdentifier: "addHomeInformationSegue", sender: self)
    }
    //Mark:- OnGetDataListener Implementation
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("MainViewController:- Got Customer Data")
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
    
}
