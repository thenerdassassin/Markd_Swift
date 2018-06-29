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
