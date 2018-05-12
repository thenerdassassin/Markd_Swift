//
//  ContractorService.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/28/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class ContractorService:CustomStringConvertible, Comparable {
    private var guid:String
    private var month:Int
    private var day:Int
    private var year:Int
    private var contractor:String
    private var comments:String
    //private var files:[FirebaseFile]?
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.guid = dictionary["guid"] != nil ? dictionary["guid"] as! String: ""
        self.month = dictionary["month"] != nil ? dictionary["month"] as! Int: -1
        self.day = dictionary["day"] != nil ? dictionary["day"] as! Int: -1
        self.year = dictionary["year"] != nil ? dictionary["year"] as! Int: -1
        self.contractor = dictionary["contractor"] != nil ? dictionary["contractor"] as! String: ""
        self.comments = dictionary["comments"] != nil ? dictionary["comments"] as! String: ""
    }
    
    public func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["guid"] = self.guid as AnyObject
        if month >= 0 {
            dictionary["month"] = self.month as AnyObject
        }
        if day >= 0 {
            dictionary["day"] = self.day as AnyObject
        }
        if year >= 0 {
            dictionary["year"] = self.year as AnyObject
        }
        dictionary["contractor"] = self.contractor as AnyObject
        dictionary["comments"] = self.comments as AnyObject
        return dictionary
    }
    
    func getGuid() -> String {
        return self.guid
    }
    func setGuid(_ guid:String?) {
        if let guid = guid {
            self.guid = guid
        } else {
            self.guid = UUID.init().uuidString
        }
    }
    
    func getMonth() -> Int {
        return self.month
    }
    func setMonth(_ month:Int) -> ContractorService {
        self.month = month
        return self
    }

    func getDay() -> Int {
        return self.day
    }
    func setDay(_ day:Int) -> ContractorService {
        self.day = day
        return self
    }
    
    func getYear() -> Int {
        return self.year
    }
    func setYear(_ year:Int) -> ContractorService {
        if year < 0 {
            return self
        }
        if year > 100 {
            self.year = year % 100
            return self
        }
        self.year = year
        return self
    }
    
    func getContractor() -> String {
        return self.contractor
    }
    func setContractor(_ contractor:String) -> ContractorService{
        self.contractor = contractor
        return self
    }
    
    func getComments() -> String {
        return self.comments
    }
    func setComments(_ comments:String) -> ContractorService{
        self.comments = comments
        return self
    }
    
    var TODO_Contractor_Service_Files😵:AnyObject?

    func update(contractor:String, comments:String) -> ContractorService{
        var TODO_Contractor_Service_Files_Update😵:AnyObject?
        self.contractor = contractor
        self.comments = comments
        return self
    }
    
    public func getDate() -> String? {
        return StringUtilities.getDateString(withMonth: month, withDay: day, withYear: year)
    }
    
    public func getUrlFormattedDate() -> String? {
        return StringUtilities.getDateString(withMonth: month, withDay: day, withYear: year, seperatedBy: "")
    }
    
    // Mark:- Comparable
    public static func < (lhs: ContractorService, rhs: ContractorService) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year > rhs.year
        }
        if lhs.month != rhs.month {
            return lhs.month > rhs.month
        }
        if lhs.day != rhs.day {
            return lhs.day > rhs.day
        }
        if lhs.contractor != rhs.contractor {
            return lhs.contractor < rhs.contractor
        }
        if lhs.comments != rhs.comments {
            return lhs.comments < rhs.comments
        }
        return lhs.guid < rhs.guid
    }
    
    public static func == (lhs: ContractorService, rhs: ContractorService) -> Bool {
        return false
    }
}
