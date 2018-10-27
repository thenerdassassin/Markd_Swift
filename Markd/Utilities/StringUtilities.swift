//
//  StringUtilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

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
        } else if(day <= 0) {
            print("Day was less than 1 it was \(day)")
            return nil
        } else if (day < 10) {
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
    
    public static func getComponentsFrom(dotFormmattedString date: String?) -> [Int?] {
        var componentsToReturn = [Int?](repeating: nil, count:3)
        guard StringUtilities.isNotNilOrEmpty(date) else {
            return componentsToReturn
        }
        
        let components = date?.split(separator: ".")
        guard components != nil && components!.count == 3 else {
            print("Date not in correct format")
            return componentsToReturn
        }
        
        componentsToReturn[0] = Int("\(components![0])")
        componentsToReturn[1] = Int("\(components![1])")
        
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(Calendar.Component.year, from: date)
        guard let year = Int("\(components![2])") else {
            return componentsToReturn
        }
        componentsToReturn[2] = year + 2000
        if(componentsToReturn[2]! > currentYear) {
            componentsToReturn[2]! -= 100
        }
        return componentsToReturn
    }
    
    public static func getFormattedName(withPrefix prefix: String, withFirstName firstName: String, withLastName lastName: String, withMaritalStatus maritalStatus: String) -> String{
        return "\(isNotNilOrEmpty(prefix) ? prefix + " " : "")\(maritalStatus == "Married" && isNotNilOrEmpty(prefix) ? "and Mrs. " : "")\(isNotNilOrEmpty(firstName) ? "\(firstName) " : "") \(lastName)"
    }
    
    public static func set(_ datePicker:UIDatePicker, to date:String) {
        let components = StringUtilities.getComponentsFrom(dotFormmattedString: date)
        if let month = components[0], let day = components[1], let year = components[2] {
            var dateComponents = DateComponents()
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.year = year
            
            let userCalendar = Calendar.current
            guard let installDate = userCalendar.date(from: dateComponents) else {
                print("installDate is null")
                return
            }
            datePicker.setDate(installDate, animated: true)
        }
    }
    
    public static func set(textOf label: UILabel, to newString: String?) {
        if(isNilOrEmpty(newString)) {
            label.text = "---"
        } else {
            label.text = newString
        }
    }
    
    public static func isNilOrEmpty(_ stringToCheck:String?) -> Bool {
        return stringToCheck == nil || stringToCheck!.replacingOccurrences(of: " ", with: "") == ""
    }
    
    private static func isNotNilOrEmpty(_ stringToCheck:String?) -> Bool {
        return !isNilOrEmpty(stringToCheck)
    }
    
    public static func removeNonNumeric(from string:String) -> String {
        return string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    public static func format(phoneNumber sourcePhoneNumber: String, isStrict:Bool) -> String? {
        if isStrict {
            return format(phoneNumber: sourcePhoneNumber)
        }
        
        let numbersOnly = removeNonNumeric(from:sourcePhoneNumber)
        var sourceIndex = numbersOnly.hasPrefix("1") ? 1 : 0
        
        let areaCodeLength = 3
        guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
            return "(" + numbersOnly
        }
        let formattedString = String(format: "(%@) ", areaCodeSubstring)
        sourceIndex += areaCodeLength
        
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return formattedString + numbersOnly.substring(start: sourceIndex, offsetBy: numbersOnly.count - sourceIndex)!
        }
        sourceIndex += prefixLength
        return formattedString + prefix + "-" + numbersOnly.substring(start: sourceIndex, offsetBy: numbersOnly.count - sourceIndex)!
    }
    
    public static func format(phoneNumber sourcePhoneNumber: String) -> String? {
        let numbersOnly = removeNonNumeric(from:sourcePhoneNumber)
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        if hasLeadingOne {
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return areaCode + prefix + "-" + suffix
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
