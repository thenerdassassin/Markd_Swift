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
    public var customerId: String?
    public var customer: Customer? {
        didSet {
            print("customer didSet")
            configureView()
        }
    }
    public var customerList: [Customer]? {
        didSet {
            print("hasCustomerList")
            configureView()
        }
    }
    public var companyName:String?
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
        configureView()
    }
    
    private func configureView() {
        print("configureView")
        if let label = customerNameLabel, let customer = customer {
            label.text = customer.getName()
        } else if let label = customerNameLabel, let _ = customerList {
            label.text = "Type message to send to all customers."
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
            if(textView.text != "") {
                sendNotification()
            } else {
                AlertControllerUtilities.showAlert(
                    withTitle: "Error",
                    andMessage: "Notification message can not be empty.",
                    withOptions: [UIAlertAction(title: "Ok", style: .default, handler: nil)],
                    in: self)
            }
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 140
    }
    
    //Mark: SendNotification
    private func sendNotification() {
        if let company = companyName, let id = customerId {
            NotificationsUtilities.sendNotification(from: company, with: notificationMessageTextView.text, to: id, successHandler: sendNotificationSuccess, errorHandler: sendNotificationFailure)
            
        } else if let company = companyName, let customers = customerList {
            //Transform list to non-nil customer Id's
            let customerIds = customers.filter { $0.customerId != nil }.map { $0.customerId! }
            NotificationsUtilities.sendNotifications(from: company, with: notificationMessageTextView.text, to: customerIds, successHandler: sendNotificationSuccess, errorHandler: sendNotificationFailure)
        } else {
            sendNotificationFailure(MarkdError.UnexpectedNil)
        }
        
    }
    func sendNotificationSuccess() {
        AlertControllerUtilities.showAlert(withTitle: "Notification Sent  📬",
                                           andMessage: nil,
                                           withOptions: [UIAlertAction(title: "Ok", style: .default, handler: {
                                                _ in self.navigationController?.popViewController(animated: true)
                                           })],
                                           in: self)
    }
    func sendNotificationFailure(_ error:Error) {
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
    
    func sendNotificationsFailure(_ error:Error) {
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}
