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
    
    private var namePrefix:String
    private var firstName:String
    private var lastName:String
    private var type:String
    private var contractorDetails:ContractorDetails?
    //private var customers: [String]
    var TODO_Customers_Field_🙄:AnyObject?
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
        //TODO: Contractor Details
        //TODO: Customers
        self.logoFileName = dictionary["logoFileName"] != nil ? dictionary["logoFileName"] as! String: ""
    }
    
    var TODO_Contractor_Getter_Setter_😤:AnyObject?
    var TODO_toDictionary_Implementations🤬:AnyObject?
    /*Mark:- Getters/Setters
    public String getNamePrefix() {
    return namePrefix;
    }
    public Contractor setNamePrefix(String namePrefix) {
    this.namePrefix = namePrefix;
    return this;
    }
    
    public String getFirstName() {
    return firstName;
    }
    public Contractor setFirstName(String firstName) {
    this.firstName = firstName;
    return this;
    }
    
    public String getLastName() {
    return lastName;
    }
    public Contractor setLastName(String lastName) {
    this.lastName = lastName;
    return this;
    }
    
    public String getType() {
    return type;
    }
    public Contractor setType(String type) {
    this.type = type;
    return this;
    }
    
    public ContractorDetails getContractorDetails() {
    return contractorDetails;
    }
    public Contractor setContractorDetails(ContractorDetails contractorDetails) {
    this.contractorDetails = contractorDetails;
    return this;
    }
    
    public List<String> getCustomers() {
    return customers;
    }
    public Contractor setCustomers(List<String> customers) {
    this.customers = customers;
    return this;
    }
    
    public String getLogoFileName() {
    return logoFileName;
    }
    public Contractor setLogoFileName() {
    this.logoFileName = UUID.randomUUID().toString();
    return this;
    }
    */
    //Mark:- Helper functions
    public func updateProfile(namePrefix:String, firstName:String, lastName:String, contractorType:String) {
        self.namePrefix = namePrefix;
        self.firstName = firstName;
        self.lastName = lastName;
        self.type = contractorType;
    }
}
