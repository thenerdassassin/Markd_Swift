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
    private var authenticator:FirebaseAuthentication = FirebaseAuthentication()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
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
    }

    //MARK:- IBAction Methods
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        signIn()
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func onCreateAccount(_ sender:UIButton) {
        displayErrorMessage()
    }
    @IBAction func onForgotPassword(_ sender: Any) {
        //From: https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        let alert = UIAlertController(title: "Send Password Recovery Email", message: "Enter your email address and we will send an email to reset your password.", preferredStyle: .alert)
        
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
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Login Handlers
    func loginSuccessHandler(_ user: User) {
        self.performSegue(withIdentifier: "Login", sender: self)
    }
    
    func loginFailureHandler(_ error: Error) {
        debugPrint(error)
        if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
                case .invalidEmail:
                    let alert = UIAlertController(title: "Invalid Email", message: "The email entered is invalid. Please type in a valid email address.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                case .wrongPassword:
                    let alert = UIAlertController(title: "Wrong username/password", message: "This user and password do not match. Please try again or click 'Forgot Password' to change it.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                case .networkError:
                    let alert = UIAlertController(title: "Network Error", message: "Make sure you are connected to internet and try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                case .userNotFound:
                    let alert = UIAlertController(title: "Create Account", message: "This account does not yet exist. Please create an account.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                default:
                    let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
    }
    
    //MARK:- Segue Methods
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "Login") {
            //TODO: send userId with segue
        }
        return true;
    }
    
    //MARK:- Helper Methods
    func signIn() {
        if let email = email, let emailString = email.text, let password = password, let passwordString = password.text {
            //Attempt firebase login
            authenticator.signIn(self, withEmail: emailString, andPassword: passwordString)
        } else {
            displayErrorMessage()
        }
    }
    
    private func displayErrorMessage() {
        let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
