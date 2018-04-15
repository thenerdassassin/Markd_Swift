//
//  Appliance.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/8/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Appliance {
    
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
        let components = StringUtilities.getComponentsFrom(dotFormmattedString: installDate)
        if let month = components[0], let day = components[1], let year = components[2] {
            self.month = month
            self.day = day
            self.year = year
        }
    }
    
    public func lifeSpanAsString() -> String {
        return "\(lifeSpan) \(units)"
    }
    public func updateLifeSpan(to lifeSpanInt: Int, _ units:String) {
        self.lifeSpan = lifeSpanInt
        self.units = units
    }
    public func updateLifeSpan(to updatedValue:String) {
        let parts = updatedValue.split(separator: " ")
        guard parts.count == 2 else {
            print("Not valid life span: \(updatedValue)")
            return
        }
        guard let lifeSpanInt = Int("\(parts[0])") else {
            print("Not valid life span: \(updatedValue)")
            return
        }
        self.lifeSpan = lifeSpanInt
        self.units = "\(parts[1])"
    }
    
    public func set(_ field: String, to updatedValue: String) {
        switch field {
            case "Manufacturer":
                self.manufacturer = updatedValue
            case "Model":
                self.model = updatedValue
            case "Install Date":
                self.updateInstallDate(to: updatedValue)
            case "Projected Life Span":
                self.updateLifeSpan(to: updatedValue)
            default:
                print("Field: \(field) does not exist")
        }
    }
}
