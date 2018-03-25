//
//  HotWater.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Boiler {
    private var manufacturer: String
    private var model: String
    private var month: Int
    private var day: Int
    private var year: Int
    private var lifeSpan: Int
    private var units: String
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.manufacturer = dictionary["manufacturer"] != nil ? dictionary["manufacturer"] as! String: ""
        self.model = dictionary["model"] != nil ? dictionary["model"] as! String: ""
        self.month = dictionary["month"] != nil ? dictionary["month"] as! Int: 0
        self.day = dictionary["day"] != nil ? dictionary["day"] as! Int: 0
        self.year = dictionary["year"] != nil ? dictionary["year"] as! Int: 0
        self.lifeSpan = dictionary["lifeSpan"] != nil ? dictionary["lifeSpan"] as! Int: 0
        self.units = dictionary["units"] != nil ? dictionary["units"] as! String: ""
        
    }
    
    public func getManufacturer() -> String {
        return self.manufacturer
    }
    public func setManufacturer(_ manufacturer:String) {
        self.manufacturer = manufacturer
    }
    
    public func getModel() -> String {
        return self.model
    }
    public func setModel(_ model:String) {
        self.model = model
    }
    
    public func installDateAsString() -> String? {
        return StringUtilities.getDateString(withMonth: month, withDay: day, withYear: year)
    }
    public func updateInstallDate(to installDate:String) {
        var TODO_Implement_DotFormattedStringGetters💩:AnyObject?
        
        //self.day = StringUtilities.getDayFromDotFormmattedString(installDate);
        //self.month = StringUtilities.getMonthFromDotFormattedString(installDate);
        //self.year = StringUtilities.getYearFromDotFormmattedString(installDate);
    }
    
    public func lifeSpanAsString() -> String {
        return "\(lifeSpan) \(units)"
    }
    public func updateLifeSpan(to lifeSpanInt: Int, _ units:String) {
        self.lifeSpan = lifeSpanInt
        self.units = units
    }
}

