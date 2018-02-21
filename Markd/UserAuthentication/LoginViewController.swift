//
//  LoginViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//
import UIKit
import Firebase

class LoginViewController: UIViewController, LoginHandler {
    private var authenticator:FirebaseAuthentication = FirebaseAuthentication()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "Login") {
            //TODO: send userId with segue
        }
        return true;
    }
    func configureView() {
        KeyboardUtilities.addKeyboardDismissal(self.view)
        
        if let loginButton = loginButton {
            loginButton.layer.cornerRadius = 10
            loginButton.clipsToBounds = true
        }
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        if let email = email, let emailString = email.text, let password = password, let passwordString = password.text {
            //Attempt firebase login
            authenticator.signIn(self, withEmail: emailString, andPassword: passwordString)
        } else {
            displayErrorMessage()
        }
    }
    
    @IBAction func onCreateAccount(_ sender:UIButton) {
        displayErrorMessage()
    }
    
    
    //LoginHandler Methods
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
    
    private func displayErrorMessage() {
        let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
