//
//  HotWater.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class HotWater {
    private var manufacturer: String
    private var model: String
    private var month: Int
    private var day: Int
    private var year: Int
    private var lifeSpan: Int
    private var units: String
    
    var TODO_InitFunction🤨:AnyObject?
    var TODO_GettersAndSetters🙃:AnyObject?
    var TODO_HelperFunction🤯:AnyObject?
    public init() {
        self.manufacturer = ""
        self.model = ""
        self.month = 0
        self.day = 5
        self.year = 2010
        self.lifeSpan = 5
        self.units = "years"
        
    }
    /*
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.bedrooms = dictionary["bedrooms"] != nil ? dictionary["bedrooms"] as! Double: 0.0
        self.squareFootage = dictionary["squareFootage"] != nil ? dictionary["squareFootage"] as! Int: 0
        self.bathrooms = dictionary["bathrooms"] != nil ? dictionary["bathrooms"] as! Double: 0.0
    }
    
    func getBedrooms() -> Double {
        return self.bedrooms
    }
    
    func setBedrooms(_ bedrooms:Double) {
        self.bedrooms = bedrooms
    }
     
     public String installDateAsString() {
     return StringUtilities.getDateString(month, day, year);
     }
     public void updateInstallDate(String installDate) {
     this.day = StringUtilities.getDayFromDotFormmattedString(installDate);
     this.month = StringUtilities.getMonthFromDotFormattedString(installDate);
     this.year = StringUtilities.getYearFromDotFormmattedString(installDate);
     }
     public String lifeSpanAsString() {
     return lifeSpan.toString() + " " + units;
     }
     public void updateLifeSpan(Integer lifeSpanInteger, String lifeSpanUnits) {
     this.lifeSpan = lifeSpanInteger;
     this.units = lifeSpanUnits;
     }
 */
}
