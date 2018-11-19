//
//  SendNotificationViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 11/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class SendNotificationViewController: UIViewController, UITextViewDelegate {
    private var contractorData: TempContractorData?
    public var customerId: String?
    public var customer: Customer? {
        didSet {
            print("customer didSet")
            configureView()
        }
    }
    private let defaultText = "Max Length: 140 Characters"
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var notificationMessageTextView: UITextView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        notificationMessageTextView.layer.borderWidth = 1
        notificationMessageTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        notificationMessageTextView.layer.cornerRadius = 5.0
        notificationMessageTextView.text = defaultText
        notificationMessageTextView.delegate = self
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SendNotificationViewController:- viewWillAppear")
        /*
        if authentication.checkLogin(self) {
            contractorData = TempContractorData(self)
        }
         */
        configureView()
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
         */
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let contractorData = contractorData {
            contractorData.removeListeners()
        }
    }
    
    private func configureView() {
        print("configureView")
        if let label = customerNameLabel, let customer = customer {
            label.text = customer.getName()
        }
    }
    
    //Mark:- UITextView Handlers
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == defaultText) {
            textView.text = ""
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            sendNotification()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 140
    }
    
    private func sendNotification() {
        if let id = customerId {
            AlertControllerUtilities.showAlert(withTitle: "Notification Sent  📬",
                                               andMessage: nil,
                                               withOptions: [UIAlertAction(title: "Ok", style: .default, handler: exit)],
                                               in: self)
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
        }
        
    }
    
    private func exit(action: UIAlertAction) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    //Mark:- OnGetDataListener Implementation
    public func onStart() {
        print("Getting Contractor Data")
    }
    
    public func onSuccess() {
        print("ContractorMainViewController:- Got Contractor Data")
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
 */
}
