//
//  HelpViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/10/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class HelpViewController: UIViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var customerData: TempCustomerData?
    private var customerEmail: String?
    @IBOutlet weak var messageTextView: UITextView!
    let sendingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
        if let messageTextView = messageTextView {
            messageTextView.text = ""
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        var TODO_look_into_background_fill_🤪: AnyObject?
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
        sendingIndicator.frame = self.view.frame
        sendingIndicator.backgroundColor = UIColor(white: 0, alpha: 0.5)
        sendingIndicator.hidesWhenStopped = true
        self.view.addSubview(sendingIndicator)
        if let messageTextView = messageTextView {
            messageTextView.layer.borderColor = UIColor.gray.cgColor
            messageTextView.layer.borderWidth = 0.5;
            messageTextView.layer.cornerRadius = 6;
        }
    }
    
    //Mark:- Navigation Buttons
    @IBAction func sendMessage(_ sender: Any) {
        sendingIndicator.startAnimating()
        if let user = customerEmail, let message = messageTextView?.text {
            print ("Send Email from \(user)")
            SendEmail.send(message, from:user, successHandler: self.sendSuccess, errorHandler: self.sendError)
        }
    }
    @IBAction func cancelNavigationButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }

    //Mark: SendEmailHandlers
    private func sendSuccess(_ data: Data?, _ response: URLResponse?) {
        OperationQueue.main.addOperation {
            self.sendingIndicator.stopAnimating()
            if let response = response as? HTTPURLResponse {
                if(response.statusCode == 200) {
                    AlertControllerUtilities.showAlert(withTitle: "Thanks 😁", andMessage: "An email has been sent to the support team. We appreciate your feedback.",
                                                       withOptions: [UIAlertAction(title: "Ok", style: .default, handler: self.emailSuccessAlertHandler)], in: self)
                } else {
                    AlertControllerUtilities.somethingWentWrong(with: self)
                }
            }
        }
    }
    private func emailSuccessAlertHandler(action:UIAlertAction) {
        print("emailSuccessAlertHandler")
        self.tabBarController?.selectedIndex = 0
    }
    private func sendError(_ error:Error) {
        OperationQueue.main.addOperation {
            debugPrint("error: \(error)")
            self.sendingIndicator.stopAnimating()
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
    }
    
    //Mark:- OnGetDataListener Implementation
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        customerEmail = authentication.getCurrentUser()?.email
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
}
