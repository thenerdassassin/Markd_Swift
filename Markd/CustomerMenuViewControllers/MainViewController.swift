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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        print("MainViewController:- viewWillAppear")
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
            var TODO_SetUpActionBar_🤪: AnyObject?
            var TODO_CameraHomeImageCapture_🤪: AnyObject?
            var TODO_HomeImageClickListeners_🤪: AnyObject?
            var TODO_LoadImage_🤪: AnyObject?
            var TODO_RealtorBuilderAndArchitect_🤪: AnyObject?
            var TODO_ContactRealtorEtcAlertAction_🤪: AnyObject?
        }
        configureView()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
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
                var TODO_GoToHomeEditViewController_🤪: AnyObject?
                streetAddressLabel.text = "Loading...."
                homeInformationLabel.text = "-- bathrooms -- bedrooms \n -- square feet"
            }
        }
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
