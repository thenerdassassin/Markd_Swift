//
//  StringUtilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class StringUtilities {
    
    public static func getDateString(withMonth month:Int, withDay day:Int, withYear year:Int, seperatedBy seperator:String) -> String? {
        var dateString = ""
        
        if(month > 12) {
            print("Month was greater than 12 it was \(month)")
            return nil
        } else if(month < 10) {
            dateString += "0"
        }
        dateString += "\(month)\(seperator)"
        
        if(day > 31) {
            print("Day was greater than 31 it was \(day)")
            return nil
        } else if (day < 31) {
            dateString += "0"
        }
        dateString += "\(day)\(seperator)"
        
        if(year > 9 && year < 100) {
            dateString += "\(year)"
        } else {
            let yearModulo100 = year%100
            if(yearModulo100 < 10) {
                dateString += "0"
            }
            dateString += "\(yearModulo100)"
        }
        
        return dateString
    }
    
    public static func getDateString(withMonth month:Int, withDay day:Int, withYear year:Int) -> String? {
       return getDateString(withMonth: month, withDay: day, withYear: year, seperatedBy: ".")
    }
    
    public static func getCurrentDateString() -> String {
        let date = Date()
        let calendar = Calendar.current
        return getDateString(withMonth: calendar.component(Calendar.Component.month, from: date),
                             withDay: calendar.component(Calendar.Component.day, from: date),
                             withYear: calendar.component(Calendar.Component.year, from: date))!
    }
    
    //TODO: getMonth/Day/Year FromDotFormattedString
    
    public static func getFormattedName(withPrefix prefix: String, withFirstName firstName: String, withLastName lastName: String, withMaritalStatus maritalStatus: String) -> String{
        return "\(isNotNilOrEmpty(prefix) ? prefix + " " : "")\(maritalStatus == "Married" && isNotNilOrEmpty(prefix) ? "and Mrs. " : "")\(isNotNilOrEmpty(firstName) ? "\(firstName) " : "") \(lastName)"
    }
    
    public static func isNilOrEmpty(_ stringToCheck:String?) -> Bool {
        return stringToCheck == nil || stringToCheck == ""
    }
    
    private static func isNotNilOrEmpty(_ stringToCheck:String?) -> Bool {
        return !isNilOrEmpty(stringToCheck)
    }
}

