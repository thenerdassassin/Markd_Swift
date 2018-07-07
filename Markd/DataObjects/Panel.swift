//
//  Panel.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/5/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Panel:CustomStringConvertible, Comparable {
    private let doublePoleBottom = "Double-Pole Bottom"
    public var isMainPanel:Bool
    public var amperage:String
    public var panelDescription:String
    public var installDate:String
    public var breakerList:[Breaker]?
    public var numberOfBreakers:Int
    public var manufacturer:String
    
    //Mark:- Constructors
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.isMainPanel = dictionary["isMainPanel"] != nil ? dictionary["isMainPanel"] as! Bool: true
        self.amperage = dictionary["amperage"] != nil ? dictionary["amperage"] as! String: ""
        self.panelDescription = dictionary["panelDescription"] != nil ? dictionary["panelDescription"] as! String: ""
        self.installDate = dictionary["installDate"] != nil ? dictionary["installDate"] as! String: ""
        if let breakersArray = dictionary["breakerList"] as? NSArray {
            breakerList = [Breaker]()
            for breaker in breakersArray {
                if let breakerDictionary = breaker as? Dictionary<String, AnyObject> {
                    breakerList!.append(Breaker(breakerDictionary))
                }
            }
        }
        self.numberOfBreakers = dictionary["numberOfBreakers"] != nil ? dictionary["numberOfBreakers"] as! Int: 0
        self.manufacturer = dictionary["manufacturer"] != nil ? dictionary["manufacturer"] as! String: ""
    }
    public init() {
        self.isMainPanel = true
        self.amperage = "1000A"
        self.panelDescription = ""
        self.breakerList = [Breaker]()
        self.installDate = StringUtilities.getCurrentDateString()
        self.manufacturer = PanelManufacturer.other.description
        self.numberOfBreakers = 1
    }
    public func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["isMainPanel"] = self.isMainPanel as AnyObject
        dictionary["amperage"] = self.amperage as AnyObject
        dictionary["panelDescription"] = self.panelDescription as AnyObject
        dictionary["installDate"] = self.installDate as AnyObject
        if let breakerList = breakerList {
            var breakerArray = NSArray()
            for breaker in breakerList {
                breakerArray = breakerArray.adding(breaker.toDictionary()) as NSArray
            }
            dictionary["breakerList"] = breakerArray
        }
        dictionary["manufacturer"] = self.manufacturer as AnyObject
        dictionary["numberOfBreakers"] = self.numberOfBreakers as AnyObject
        return dictionary
    }
    
    //Mark:- Getters/Setters
    public func setInstallDate(month:Int, day:Int, year:Int) -> Panel {
        let newDate = StringUtilities.getDateString(withMonth: month, withDay: day, withYear: year)
        if let newDate = newDate {
            self.installDate = newDate
        }
        return self
    }
    public func getNumberOfBreakers() -> Int {
        return self.numberOfBreakers
    }
    public func setNumberOfBreakers(_ numberOfBreakers:Int) -> Panel {
        self.numberOfBreakers = numberOfBreakers
         if(breakerList == nil) {
            breakerList = [Breaker]();
         }
         while(breakerList!.count < numberOfBreakers) {
            let breakerToAdd = Breaker(breakerList!.count+1)
            self.breakerList!.append(breakerToAdd)
         }
         
         while(breakerList!.count > numberOfBreakers) {
            self.deleteBreaker(breakerList!.count)
         }
        return self
    }
    public func getPanelTitle() -> String {
        var panelTitle:String
        if isMainPanel {
            panelTitle = "Main Panel \(self.amperage)"
        } else {
            panelTitle = "Sub Panel \(self.amperage)"
        }
        return panelTitle
    }
    public func deleteBreaker(_ breakerNumber:Int) -> Panel {
        let breakerIndex = breakerNumber - 1;
        
        //Error check
        guard let breakerList = breakerList else {
            return self;
        }
        if(breakerNumber > breakerList.count) {
            return self;
        }
        let lastBreaker = breakerList[breakerList.count - 1];
        let breakerToDelete = breakerList[breakerIndex];
    
        if(breakerToDelete.breakerType == BreakerType.doublePoleBottom.description) {
            self.breakerList![breakerIndex-2].breakerType = BreakerType.singlePole.description;
        } else if(breakerToDelete.breakerType == BreakerType.doublePole.description) {
            breakerToDelete.breakerType = BreakerType.singlePole.description;
            self.breakerList![breakerIndex+2].breakerType = BreakerType.singlePole.description;
        }
        if(breakerToDelete.number == lastBreaker.number) {
            self.breakerList!.remove(at: breakerIndex);
        } else {
            //Reset to default values
            breakerToDelete.breakerDescription = "";
            breakerToDelete.breakerType = BreakerType.singlePole.description;
            breakerToDelete.amperage = BreakerAmperage.twenty.description;
            self.breakerList![breakerIndex] = breakerToDelete
        }
        return self;
    }
    
    //Mark: Comparable
    public static func < (lhs: Panel, rhs: Panel) -> Bool {
        let lhsComponents = StringUtilities.getComponentsFrom(dotFormmattedString: lhs.installDate)
        let rhsComponents = StringUtilities.getComponentsFrom(dotFormmattedString: rhs.installDate)
        
        //Year
        if lhsComponents[2]! != rhsComponents[2]! {
            return lhsComponents[2]! > rhsComponents[2]!
        }
        //Month
        if lhsComponents[0]! != rhsComponents[0]! {
            return lhsComponents[0]! > rhsComponents[0]!
        }
        //Day
        if lhsComponents[1]! != rhsComponents[1]! {
            return lhsComponents[1]! > rhsComponents[1]!
        }
        return lhs.panelDescription < rhs.panelDescription
    }
    
    public static func == (lhs: Panel, rhs: Panel) -> Bool {
        return false
    }
    public func editBreaker(index breakerIndex: Int, to updatedBreaker: Breaker) -> Panel {
        self.breakerList![breakerIndex] = updatedBreaker
        
        // Updated Breaker is top of Double-Pole
        if(updatedBreaker.breakerType == BreakerType.doublePole.description) {
            // Need to Add Breakers to Panel
            if(breakerIndex + 2 >= breakerList!.count) {
                while(breakerIndex + 2 > breakerList!.count) {
                    let breakerToAdd = Breaker(breakerList!.count + 1)
                    self.breakerList!.append(breakerToAdd)
                    numberOfBreakers = numberOfBreakers + 1
                }
                let breakerToAdd = Breaker(breakerList!.count + 1)
                breakerToAdd.breakerDescription = updatedBreaker.breakerDescription
                breakerToAdd.amperage = updatedBreaker.amperage
                breakerToAdd.breakerType = doublePoleBottom
                numberOfBreakers = numberOfBreakers + 1
                self.breakerList!.append(breakerToAdd)
            }
            // Simply update the bottom of Double Pole
            else {
                self.breakerList![breakerIndex+2].breakerType = doublePoleBottom
                self.breakerList![breakerIndex+2].breakerDescription = updatedBreaker.breakerDescription
                self.breakerList![breakerIndex+2].amperage = updatedBreaker.amperage
            }
        }
        // Updated Breaker is bottom of Double-Pole
        else if(updatedBreaker.breakerType == doublePoleBottom) {
            //Copy Changes to Upper Part of Double-Pole
            self.breakerList![breakerIndex-2].breakerDescription = updatedBreaker.breakerDescription
            self.breakerList![breakerIndex-2].amperage = updatedBreaker.amperage
        }
        // Updated Breaker is Single-Pole
        else {
            //Set above breaker to single pole
            if breakerIndex > 1 {
                let aboveBreaker = breakerList![breakerIndex-2]
                if aboveBreaker.breakerType == BreakerType.doublePole.description {
                    aboveBreaker.breakerType = BreakerType.singlePole.description
                    self.breakerList![breakerIndex-2] = aboveBreaker
                }
            }
            //Set below breaker to single pole
            if breakerIndex + 2 < self.breakerList!.count {
                let belowBreaker = breakerList![breakerIndex+2]
                if belowBreaker.breakerType == doublePoleBottom {
                    belowBreaker.breakerType = BreakerType.singlePole.description
                    self.breakerList![breakerIndex+2] = belowBreaker
                }
            }
        }
        return self
    }
}
