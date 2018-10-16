//
//  LoginViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//
import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate, LoginHandler {
    private var authenticator:FirebaseAuthentication = FirebaseAuthentication.sharedInstance
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let email = email, let password = password {
            email.text = ""
            password.text = ""
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if authenticator.checkLogin(self) {
            login()
        }
    }
    
    func configureView() {
        KeyboardUtilities.addKeyboardDismissal(self.view)
        if let loginButton = loginButton {
            loginButton.layer.cornerRadius = 10
            loginButton.clipsToBounds = true
        }
        
        if let password = password {
            password.delegate = self
        }
        
        if(authenticator.checkLogin(self)) {
            loginSuccessHandler(authenticator.getCurrentUser()!)
        }
    }

    //MARK:- IBAction Methods
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        signIn()
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        signIn()
    }
    @IBAction func onForgotPassword(_ sender: Any) {
        //From: https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        let alert = UIAlertController(title: "Recovery Email", message: "Enter your email address and we will send an email to reset your password.", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
             // Force unwrapping because we know it exists.
            if let email = alert!.textFields![0].text {
                self.authenticator.forgotPassword(self, withEmail: email)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onCreateAccount(_ sender: UIButton) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Account Type",
            andMessage: "Are you a home owner or contractor?",
            withOptions: [
                UIAlertAction(title: "Home Owner", style: .default, handler: {_ in self.performSegue(withIdentifier: "createCustomerSegue", sender: sender)}),
                UIAlertAction(title: "Contractor", style: .default, handler: {_ in self.performSegue(withIdentifier: "createContractorSegue", sender: sender)}),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ], in: self)
    }
    //MARK:- Login Handlers
    private func login() {
        authenticator.getUserType(in: self, listener: performLoginSegue)
    }
    func loginSuccessHandler(_ user: User) {
        login()
    }
    
    func loginFailureHandler(_ error: Error) {
        debugPrint(error)
        authenticator.errorHandler(self, forError: error)
    }
    
    //MARK:- Segue Methods
    private func performLoginSegue(snapShot: DataSnapshot) {
        guard let snapShotDictionary = snapShot.value as? Dictionary<String, AnyObject> else {
            authenticator.signOut(self)
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
            return
        }
        let userType = snapShotDictionary["userType"] as? String
        if(userType == "customer") {
            self.performSegue(withIdentifier: "CustomerLogin", sender: self)
        } else if (userType == "contractor") {
            self.performSegue(withIdentifier: "ContractorLogin", sender: self)
        } else {
            authenticator.signOut(self)
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
    }
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {}
    
    //MARK:- Helper Methods
    func signIn() {
        if let email = email, let emailString = email.text, let password = password, let passwordString = password.text {
            authenticator.signIn(self, withEmail: emailString, andPassword: passwordString)
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
        }
    }
}
