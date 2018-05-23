//
//  PaintSurface.swift
//  Markd
//
//  Created by Joshua Schmidt on 5/19/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class PaintSurface:CustomStringConvertible, Comparable {
    private var brand:String
    private var color:String
    private var location:String
    private var month:Int
    private var day:Int
    private var year:Int
    
    public init() {
        self.brand = ""
        self.color = ""
        self.location = ""
        self.month = -1
        self.day = -1
        self.year = -1
    }
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.brand = dictionary["brand"] != nil ? dictionary["brand"] as! String: ""
        self.color = dictionary["color"] != nil ? dictionary["color"] as! String: ""
        self.location = dictionary["location"] != nil ? dictionary["location"] as! String: ""
        self.month = dictionary["month"] != nil ? dictionary["month"] as! Int: -1
        self.day = dictionary["day"] != nil ? dictionary["day"] as! Int: -1
        self.year = dictionary["year"] != nil ? dictionary["year"] as! Int: -1
    }
    public func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["brand"] = self.brand as AnyObject
        dictionary["color"] = self.color as AnyObject
        dictionary["location"] = self.location as AnyObject
        if(month != -1 && day != -1 && year != -1) {
            dictionary["month"] = self.month as AnyObject
            dictionary["day"] = self.day as AnyObject
            dictionary["year"] = self.year as AnyObject
        }
        return dictionary
    }
    
    public func getLocation() -> String {
        return self.location
    }
    public func setLocation(to location:String) {
        self.location = location
    }
    public func getBrand() -> String {
        return self.brand
    }
    public func setBrand(to brand:String) {
        self.brand = brand
    }
    public func getColor() -> String {
        return self.color
    }
    public func setColor(to color:String) {
        self.color = color
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
    
    // Mark:- Comparable
    public static func < (lhs: PaintSurface, rhs: PaintSurface) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year > rhs.year
        }
        if lhs.month != rhs.month {
            return lhs.month > rhs.month
        }
        if lhs.day != rhs.day {
            return lhs.day > rhs.day
        }
        if lhs.brand != rhs.brand {
            return lhs.brand < rhs.brand
        }
        if lhs.color != rhs.color {
            return lhs.color < rhs.color
        }
        return lhs.location < rhs.location
    }
    
    public static func == (lhs: PaintSurface, rhs: PaintSurface) -> Bool {
        return false
    }
}
