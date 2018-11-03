//
//  Address.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Address:CustomStringConvertible {
    private var street: String
    private var city: String
    private var state: String
    private var zipCode: String
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.street = dictionary["street"] != nil ? dictionary["street"] as! String: ""
        self.city = dictionary["city"] != nil ? dictionary["city"] as! String: ""
        self.state = dictionary["state"] != nil ? dictionary["state"] as! String: ""
        self.zipCode = dictionary["zipCode"] != nil ? dictionary["zipCode"] as! String: ""
    }
    public func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["street"] = self.street as AnyObject
        dictionary["city"] = self.city as AnyObject
        dictionary["state"] = self.state as AnyObject
        dictionary["zipCode"] = self.zipCode as AnyObject
        return dictionary
    }
    public init() {
        self.street = ""
        self.city = ""
        self.state = ""
        self.zipCode = ""
    }
    
    func getStreet() -> String {
        return self.street
    }
    
    func setStreet(_ street:String) {
        self.street = street
    }
    
    func getCity() -> String {
        return self.city
    }
    
    func setCity(_ city: String) {
        self.city = city
    }
    
    func getState() -> String {
        return self.state
    }
    
    func setState(_ state: String) {
        self.state = state
    }
    
    func getZipCode() -> String {
        return self.zipCode
    }
    
    func setZipCode(_ zipCode: String) {
        self.zipCode = zipCode
    }
    
    func toString() -> String {
        return "\(street) \(city), \(state) \(zipCode)"
    }
}
