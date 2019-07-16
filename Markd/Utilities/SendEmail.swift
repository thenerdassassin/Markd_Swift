//
//  SendEmail.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/13/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import Firebase

public struct SendEmail {
    private static let database:DatabaseReference = Database.database().reference().child("support");
    private struct EmailMessage {
        let from:String
        let message:String
        let date:String
        
        init(from email:String, message: String, date:String) {
            self.from = email
            self.message = message
            self.date = date
        }
        
        public func toDictionary() -> Dictionary<String, AnyObject> {
            var dictionary = Dictionary<String, AnyObject>()
            dictionary["from"] = self.from as AnyObject
            dictionary["message"] = self.message as AnyObject
            dictionary["date"] = self.date as AnyObject
            return dictionary
        }
    }
    
    public static func send(_ message: String, from email:String, successHandler: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        database.child(StringUtilities.getCurrentDateString(seperatedBy: "/") + "/" + UUID().uuidString).setValue(
            EmailMessage(from: email, message:message, date:StringUtilities.getCurrentDateString()).toDictionary()
        ) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                errorHandler(error)
            } else {
                print("Data saved successfully!")
                successHandler()
            }
        }
    }
}
