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
    private let defaultText = "Max Length: 140 Characters"
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var notificationMessageTextView: UITextView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SendNotificationViewController:- viewWillAppear")
        /*
        if authentication.checkLogin(self) {
            contractorData = TempContractorData(self)
        }
         */
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
         */
        configureView()
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false;
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let contractorData = contractorData {
            contractorData.removeListeners()
        }
    }
    
    private func configureView() {
        notificationMessageTextView.layer.borderWidth = 1
        notificationMessageTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        notificationMessageTextView.layer.cornerRadius = 5.0
        notificationMessageTextView.text = defaultText
        notificationMessageTextView.delegate = self
    }
    
    //Mark:- UITextView Handlers
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == defaultText) {
            textView.text = ""
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 140
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
