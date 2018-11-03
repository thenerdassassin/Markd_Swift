//
//  Contractor.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Contractor:CustomStringConvertible {
    public final let userType = "contractor"
    public static let contractorTypes = ["Plumber", "Hvac", "Electrician", "Painter"]
    
    private var namePrefix:String
    private var firstName:String
    private var lastName:String
    private var type:String
    private var contractorDetails:ContractorDetails?
    private var customers: [String]
    private var logoFileName: String
    
    //Constructors
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.namePrefix = dictionary["namePrefix"] != nil ? dictionary["namePrefix"] as! String: ""
        self.firstName = dictionary["firstName"] != nil ? dictionary["firstName"] as! String: ""
        self.lastName = dictionary["lastName"] != nil ? dictionary["lastName"] as! String: ""
        self.type = dictionary["type"] != nil ? dictionary["type"] as! String: ""
        if let detailsDictionary = dictionary["contractorDetails"] as? Dictionary<String, AnyObject> {
            self.contractorDetails = ContractorDetails(detailsDictionary)
        }
        customers = []
        if let customersArray = dictionary["customers"] as? NSArray {
            for customer in customersArray {
                if let customerString = customer as? String {
                   customers.append(customerString)
                }
            }
        }
        customers.sort()
        self.logoFileName = dictionary["logoFileName"] != nil ? dictionary["logoFileName"] as! String: ""
    }
    func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        
        dictionary["namePrefix"] = self.namePrefix as AnyObject
        dictionary["firstName"] = self.firstName as AnyObject
        dictionary["lastName"] = self.lastName as AnyObject
        dictionary["type"] = self.type as AnyObject
        dictionary["contractorDetails"] = self.contractorDetails?.toDictionary() as AnyObject
        dictionary["logoFileName"] = self.logoFileName as AnyObject
        let customers = self.customers.sorted()
        var customersArray = NSArray()
        for customer in customers {
            customersArray = customersArray.adding(customer) as NSArray
        }
        dictionary["customers"] = customersArray
        dictionary["userType"] = self.userType as AnyObject
        
        return dictionary
    }
    
    //Mark:- Getters/Setters
    public func getNamePrefix() -> String {
        return self.namePrefix
    }
    public func setNamePrefix(to namePrefix: String) -> Contractor {
        self.namePrefix = namePrefix
        return self
    }
    
    public func getFirstName() -> String {
        return self.firstName
    }
    public func setFirstName(to firstName: String) -> Contractor {
        self.firstName = firstName
        return self
    }
    
    public func getLastName() -> String {
        return self.lastName
    }
    public func setLastName(to lastName:String) -> Contractor {
        self.lastName = lastName
        return self
    }
    
    public func getType() -> String {
        return self.type
    }
    public func setType(to type:String) -> Contractor{
        self.type = type
        return self
    }
    
    public func getContractorDetails() -> ContractorDetails? {
        return self.contractorDetails
    }
    public func setContractorDetails(to contractorDetails:ContractorDetails) -> Contractor {
        self.contractorDetails = contractorDetails
        return self
    }
    
    public func getLogoFileName() -> String {
        return self.logoFileName
    }
    public func setLogoFileName() -> Contractor {
        self.logoFileName = UUID.init().uuidString
        return self
    }
    
    public func getCustomers() -> [String] {
        return customers
    }
    public func setCustomers(to customers:[String]) -> Contractor {
        self.customers = customers
        return self
    }
    
    //Mark:- Helper functions
    public func updateProfile(namePrefix:String, firstName:String, lastName:String, contractorType:String) -> Contractor {
        self.namePrefix = namePrefix
        self.firstName = firstName
        self.lastName = lastName
        self.type = contractorType
        return self
    }
}
