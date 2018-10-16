//
//  ContractorDetails.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class ContractorDetails:CustomStringConvertible {
    private var companyName:String
    private var telephoneNumber:String
    private var websiteUrl:String
    private var zipCode:String
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.companyName = dictionary["companyName"] != nil ? dictionary["companyName"] as! String: ""
        self.telephoneNumber = dictionary["telephoneNumber"] != nil ? dictionary["telephoneNumber"] as! String: ""
        self.websiteUrl = dictionary["websiteUrl"] != nil ? dictionary["websiteUrl"] as! String: ""
        self.zipCode = dictionary["zipCode"] != nil ? dictionary["zipCode"] as! String: ""
    }
    func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        
        dictionary["companyName"] = self.companyName as AnyObject
        dictionary["telephoneNumber"] = self.telephoneNumber as AnyObject
        dictionary["websiteUrl"] = self.websiteUrl as AnyObject
        dictionary["zipCode"] = self.zipCode as AnyObject
        
        return dictionary
    }
    //Mark:- Getters/Setters
    public func getCompanyName() -> String {
        return self.companyName
    }
    public func setCompanyName(to companyName:String) -> ContractorDetails {
        self.companyName = companyName
        return self
    }
    
    public func getTelephoneNumber() -> String? {
        return StringUtilities.format(phoneNumber: self.telephoneNumber)
    }
    public func setTelephoneNumber(to telephoneNumber:String) -> ContractorDetails {
        let phoneNumber = telephoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options:.regularExpression)
        if phoneNumber.count == 10 {
            self.telephoneNumber = phoneNumber
        }
        return self
    }
    
    public func getWebsiteUrl() -> String {
        return self.websiteUrl
    }
    public func setWebsiteUrl(to websiteUrl: String) -> ContractorDetails {
        self.websiteUrl = websiteUrl
        return self
    }
    
    public func getZipCode() -> String {
        return self.zipCode
    }
    public func setZipCode(to zipCode: String) -> ContractorDetails {
        self.zipCode = zipCode
        return self
    }
}


