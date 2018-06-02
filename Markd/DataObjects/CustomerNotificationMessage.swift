//
//  CustomerNotificationMessage.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/2/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
public class CustomerNotificationMessage:CustomStringConvertible, Comparable {
    private var dateSent: String
    private var companyFrom: String
    private var message: String
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.dateSent = dictionary["dateSent"] != nil ? dictionary["dateSent"] as! String: ""
        self.companyFrom = dictionary["companyFrom"] != nil ? dictionary["companyFrom"] as! String: ""
        self.message = dictionary["message"] != nil ? dictionary["message"] as! String: ""
    }
    public func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["dateSent"] = self.dateSent as AnyObject
        dictionary["companyFrom"] = self.companyFrom as AnyObject
        dictionary["message"] = self.message as AnyObject
        return dictionary
    }
    
    func getDateSent() -> String {
        return self.dateSent
    }
    func setDateSent(_ date:String) {
        self.dateSent = date
    }
    
    func getCompanyFrom() -> String {
        return self.companyFrom
    }
    func setCompanyFrom(_ company: String) {
        self.companyFrom = company
    }
    
    func getMessage() -> String {
        return self.message
    }
    func setMessage(_ message: String) {
        self.message = message
    }
    
    // Mark:- Comparable
    public static func < (lhs: CustomerNotificationMessage, rhs: CustomerNotificationMessage) -> Bool {
        let lhsComponents = StringUtilities.getComponentsFrom(dotFormmattedString: lhs.getDateSent())
        let rhsComponents = StringUtilities.getComponentsFrom(dotFormmattedString: rhs.getDateSent())
        
        //Year
        if lhsComponents[2]! != rhsComponents[2]! {
            return lhsComponents[2]! > rhsComponents[2]!
        }
        //Month
        if lhsComponents[0]! != rhsComponents[0]! {
            return lhsComponents[0]! > rhsComponents[0]!
        }
        //Day
        if lhsComponents[1]! != rhsComponents[1]! {
            return lhsComponents[1]! > rhsComponents[1]!
        }
        
        if lhs.companyFrom != rhs.companyFrom {
            return lhs.companyFrom < rhs.companyFrom
        }
        return lhs.message < rhs.message
    }
    
    public static func == (lhs: CustomerNotificationMessage, rhs: CustomerNotificationMessage) -> Bool {
        return (lhs.dateSent == rhs.dateSent && lhs.companyFrom == rhs.companyFrom && lhs.message == rhs.message)
    }
}
