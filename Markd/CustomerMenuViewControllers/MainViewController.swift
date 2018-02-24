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
            //TODO: go to Login Screen
        } else {
            customerData = TempCustomerData(self)
        }
    }
    
    override public func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
    }
    
    func configureView() {
        //TODO: setUpView with Customer info
        if let preparedForLabel = preparedForLabel, let customerData = customerData {
            preparedForLabel.text = "Prepared For \(customerData.getName())"
        }
    }
    
}
