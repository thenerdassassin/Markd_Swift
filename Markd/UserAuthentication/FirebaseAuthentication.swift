//
//  FirebaseAuthentication.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import os.log
import Firebase

public class FirebaseAuthentication {
    static let sharedInstance = FirebaseAuthentication()
    static private let auth:Auth = Auth.auth()
    static var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    
    private init() {}
    
    func signIn(_ sender: LoginHandler, withEmail email: String, andPassword password: String) {
        FirebaseAuthentication.auth.signIn(withEmail: email, password: password) {  (authDataResult, error) in
            if let error = error {
                print("Error: ", error)
                sender.loginFailureHandler(error)
            }
            if let user = authDataResult?.user {
                print("User:" , user)
                sender.storeToken(user)
                sender.loginSuccessHandler(user)
            }
        }
    }
    
    func signOut(_ sender: UIViewController) {
        if let user = FirebaseAuthentication.auth.currentUser {
            removeToken(user)
        }
        do {
            try FirebaseAuthentication.auth.signOut()
            if !(sender is LoginViewController) {
                sender.performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            errorHandler(sender, forError: signOutError)
        }
    }
    
    func removeToken(_ user:User) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let deviceToken = appDelegate.token {
            let reference = Database.database().reference().child("tokens").child(user.uid).child(deviceToken)
            reference.removeValue()
        }
    }
    
    func getCurrentUser() -> User? {
        return FirebaseAuthentication.auth.currentUser
    }
    
    func checkLogin(_ sender: UIViewController) -> Bool {
        FirebaseAuthentication.authStateDidChangeHandle = FirebaseAuthentication.auth.addStateDidChangeListener { (auth, user) in
            if user == nil {
                if !(sender is LoginViewController) {
                    sender.performSegue(withIdentifier:"unwindToLoginSegue", sender:sender)
                }
            }
        }
        let isLoggedIn:Bool = getCurrentUser() != nil
        if(!isLoggedIn) {
            if !(sender is LoginViewController) {
                sender.performSegue(withIdentifier:"unwindToLoginSegue", sender:sender)
            }
        }
        return isLoggedIn
    }
    
    func removeStateListener() {
        if let handle = FirebaseAuthentication.authStateDidChangeHandle {
            FirebaseAuthentication.auth.removeStateDidChangeListener(handle)
        }
    }
    
    func getAuthCredential(withEmail email:String, andPassword password: String) -> AuthCredential {
        return EmailAuthProvider.credential(withEmail: email, password: password)
    }
    func getUserType(in viewController: UIViewController, listener:@escaping (DataSnapshot) -> Void) {
        guard let user = getCurrentUser() else {
            AlertControllerUtilities.somethingWentWrong(with: viewController, because: MarkdError.UnexpectedNil)
            return
        }
        let database:DatabaseReference = Database.database().reference().child("users").child(user.uid)
        database.observeSingleEvent(of: .value, with: listener)
    }
    
    func forgotPassword(_ viewController: UIViewController, withEmail email:String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                self.errorHandler(viewController, forError: error)
            } else {
                AlertControllerUtilities.showAlert(withTitle: "Email Sent 😎", andMessage: "\(email) will receive a reset password email.",
                    withOptions: [UIAlertAction(title: "Ok", style: .default, handler: nil)],
                    in: viewController)
            }
        }
    }
    func createUser(_ sender: LoginHandler, withEmail email: String, andPassword password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {  (authDataResult, error) in
            if let error = error {
                print("Error: ", error)
                sender.loginFailureHandler(error)
            }
            if let user = authDataResult?.user {
                print("User:" , user)
                sender.storeToken(user)
                sender.loginSuccessHandler(user)
            }
        }
    }
    
    func errorHandler(_ viewController: UIViewController, forError error: Error) {
        if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .invalidEmail:
                let alert = UIAlertController(title: "Invalid Email", message: "The email entered is invalid. Please type in a valid email address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            case .wrongPassword:
                let alert = UIAlertController(title: "Wrong username/password", message: "This user and password do not match. Please try again or recover password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            case .networkError:
                let alert = UIAlertController(title: "Network Error", message: "Make sure you are connected to internet and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            case .userNotFound:
                let alert = UIAlertController(title: "Create Account", message: "This account does not yet exist. Please create an account.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            case .emailAlreadyInUse:
                let alert = UIAlertController(title: "Invalid Email", message: "The email address is already in use by another account.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            default:
                let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            }
        }
    }
}
