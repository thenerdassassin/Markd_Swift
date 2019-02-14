//
//  Breaker.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/13/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Breaker:CustomStringConvertible {
    public var number:Int
    public var breakerDescription:String
    public var amperage:String
    public var breakerType:String
    
    //Mark:- Constructors
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.number = dictionary["number"] != nil ? dictionary["number"] as! Int: -1
        self.breakerDescription = dictionary["breakerDescription"] != nil ? dictionary["breakerDescription"] as! String: ""
        self.amperage = dictionary["amperage"] != nil ? dictionary["amperage"] as! String: ""
        self.breakerType = dictionary["breakerType"] != nil ? dictionary["breakerType"] as! String: ""
    }
    public init(_ number:Int) {
        self.number = number
        self.breakerDescription = ""
        self.amperage = BreakerAmperage.fifteen.description
        self.breakerType = BreakerType.singlePole.description
    }
    public func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["number"] = self.number as AnyObject
        dictionary["breakerDescription"] = self.breakerDescription as AnyObject
        dictionary["amperage"] = self.amperage as AnyObject
        dictionary["breakerType"] = self.breakerType as AnyObject
        return dictionary
    }
}

enum BreakerType: Int, CustomStringConvertible {
    case singlePole = 0
    case doublePole = 1
    case doublePoleBottom = 2
    
    //Number Shown to Public
    static var count: Int { return 2 } //Don't have Double Pole Bottom in Count
    
    //Note: Add Descriptions when adding more amperages
    var description: String {
        switch self {
        case .singlePole: return "Single-Pole"
        case .doublePole: return "Double-Pole"
        case .doublePoleBottom: return "Double-Pole Bottom"
        }
    }
}

enum BreakerAmperage: Int, CaseIterable,CustomStringConvertible {
    case fifteen = 0
    case twenty = 1
    case thirty = 2
    case fourty = 3
    case fifty = 4
    case sixty = 5
    case seventy = 6
    case eighty = 7
    case oneHundred = 8
    case oneHundredTwentyFive = 9
    case oneHundredFifty = 10
    case twoHundred = 11
    
    //Note: Change Fifty to last case if adding more amperages
    static var count: Int { return BreakerAmperage.allCases.count }
    
    //Note: Add Descriptions when adding more amperages
    var description: String {
        switch self {
        case .fifteen: return "15A"
        case .twenty: return "20A"
        case .thirty: return "30A"
        case .fourty: return "40A"
        case .fifty: return "50A"
        case .sixty: return "60A"
        case .seventy: return "70A"
        case .eighty: return "80A"
        case .oneHundred: return "100A"
        case .oneHundredTwentyFive: return "125A"
        case .oneHundredFifty: return "150A"
        case .twoHundred: return "200A"
        }
    }
    static func getRawValue(from amperage:String?) -> BreakerAmperage {
        switch amperage {
        case "15A": return .fifteen
        case "20A": return .twenty
        case "30A": return .thirty
        case "40A": return .fourty
        case "50A": return .fifty
        case "60A": return .sixty
        case "70A": return .seventy
        case "80A": return .eighty
        case "100A": return .oneHundred
        case "125A": return .oneHundredTwentyFive
        case "150A": return .oneHundredFifty
        case "200A": return .twoHundred
        default: return .fifteen
        }
    }
}
