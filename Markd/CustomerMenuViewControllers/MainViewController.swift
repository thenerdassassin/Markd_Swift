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
    
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if(!authentication.checkLogin()) {
            var TODO_GoToLoginViewController_🤪: AnyObject?
        } else {
            customerData = TempCustomerData(self)
        }
    }
    
    override public func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
    }
    
    func configureView() {
        if let customerData = customerData, let preparedForLabel = preparedForLabel, let streetAddressLabel = streetAddressLabel, let homeInformationLabel = homeInformationLabel {
            preparedForLabel.text = "Prepared for \(customerData.getName())"
            if let streetAddress = customerData.getFormattedAddress() {
                streetAddressLabel.text = "\(streetAddress)"
            } else {
                var TODO_GoToHomeEditViewController_🤪: AnyObject?
            }
            if let roomInformation = customerData.getRoomInformation(), let squareFootage = customerData.getSquareFootageString() {
                homeInformationLabel.text = "\(roomInformation) \n\(squareFootage)"
            } else {
                var TODO_GoToHomeEditViewController_🤪: AnyObject?
            }
        }
    
    }
    
}
