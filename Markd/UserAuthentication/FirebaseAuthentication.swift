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

    func signIn(_ sender: LoginHandler, withEmail email: String, andPassword password: String){
        Auth.auth().signIn(withEmail: email, password: password) {  (user, error) in
            if let error = error {
                print("Error: ", error)
                //Error
                sender.loginFailureHandler(error)
            }
            if let user = user {
                print("User:" , user)
                sender.loginSuccessHandler(user)
            }
        }
    }
}
