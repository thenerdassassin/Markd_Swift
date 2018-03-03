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
    func NEED_TO_ADD_ANDROID_METHODS😤() {
        var NEED_TO_ADD_ANDROID_METHODS😤:AnyObject?
        //TODO: token handling
        //TODO: getUserType
    }
    static let sharedInstance = FirebaseAuthentication()
    static private let auth:Auth = Auth.auth()
    static var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    
    private init() {}
    
    func signIn(_ sender: LoginHandler, withEmail email: String, andPassword password: String) {
        FirebaseAuthentication.auth.signIn(withEmail: email, password: password) {  (user, error) in
            if let error = error {
                print("Error: ", error)
                sender.loginFailureHandler(error)
            }
            if let user = user {
                print("User:" , user)
                sender.loginSuccessHandler(user)
            }
        }
    }
    
    func signOut() {
        do {
            try FirebaseAuthentication.auth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func getCurrentUser() -> User? {
        return FirebaseAuthentication.auth.currentUser
    }
    
    func checkLogin(_ sender: UIViewController) -> Bool {
        FirebaseAuthentication.authStateDidChangeHandle = FirebaseAuthentication.auth.addStateDidChangeListener { (auth, user) in
            if user == nil {
                sender.performSegue(withIdentifier:"goToLoginViewController", sender:sender)
            }
        }
        let isLoggedIn:Bool = getCurrentUser() != nil
        if(!isLoggedIn) {
            sender.performSegue(withIdentifier:"goToLoginViewController", sender:sender)
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
    
    func forgotPassword(_ errorHandler:LoginHandler, withEmail email:String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                errorHandler.loginFailureHandler(error)
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
                let alert = UIAlertController(title: "Wrong username/password", message: "This user and password do not match. Please try again or click 'Forgot Password' to change it.", preferredStyle: .alert)
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
            default:
                let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            }
        }
    }
}
