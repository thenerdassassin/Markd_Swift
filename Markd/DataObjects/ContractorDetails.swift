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
    
    var TODO_Contractor_Getter_Setter_😤:AnyObject?
    var TODO_toDictionary_Implementations🤬:AnyObject?
    /*
     //Mark:- Getters/Setters
     public String getCompanyName() {
     return companyName;
     }
     public ContractorDetails setCompanyName(String companyName) {
     this.companyName = companyName;
     return this;
     }
     
     public String getTelephoneNumber() {
     if(telephoneNumber == null) {
     return "";
     }
     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
     return PhoneNumberUtils.formatNumber(telephoneNumber, Locale.getDefault().getCountry());
     } else {
     return PhoneNumberUtils.formatNumber(telephoneNumber); //Deprecated method
     }
     }
     public ContractorDetails setTelephoneNumber(String telephoneNumber) {
     telephoneNumber = telephoneNumber.replaceAll("[^0-9]", "");
     if(telephoneNumber.length() != 10) {
     return this;
     }
     this.telephoneNumber = telephoneNumber;
     return this;
     }
     
     public String getWebsiteUrl() {
     return websiteUrl;
     }
     public ContractorDetails setWebsiteUrl(String websiteUrl) {
     this.websiteUrl = websiteUrl;
     return this;
     }
     
     public String getZipCode() {
     return zipCode;
     }
     public ContractorDetails setZipCode(String zipCode) {
     this.zipCode = zipCode;
     return this;
     }
    */
}
