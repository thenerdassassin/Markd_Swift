//
//  Panel.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/5/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Panel:CustomStringConvertible, Comparable {
    var TODO_BreakerList_Implementation_🤬:AnyObject?
    public var isMainPanel:Bool
    public var amperage:String //PanelAmperage?
    public var panelDescription:String
    public var installDate:String
    public var breakerList:[Breaker]?
    public var numberOfBreakers:Int
    public var manufacturer:String //PanelManufacturer?
    
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
            print("Adding Breaker")
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
        if(breakerToDelete.number ==  lastBreaker.number) {
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
}

/*
 
 //Helper functions
 public Panel editBreaker(int breakerNumber, Breaker updatedBreaker) {
    Log.d(TAG, "BreakerNumber:" + breakerNumber);
    int breakerIndex = breakerNumber-1;
    this.breakerList.set(breakerIndex, updatedBreaker);
     // Updated Breaker is top of Double-Pole
     if(updatedBreaker.getBreakerType().equals(Breaker.DoublePole)) {
        Log.d(TAG, "Updated Breaker is top of Double Pole");
        // Add Breakers to Panel if needed
        if(breakerIndex+2  >= this.breakerCount()) {
            Log.d(TAG, "Need to add breakers to panel");
            while(breakerIndex+2 > this.breakerCount()) {
                Log.d(TAG, "Breaker added at:" + (breakerCount()+1));
                this.breakerList.add(this.breakerCount(), new Breaker(this.breakerCount()+1, ""));
                numberOfBreakers++;
            }
            Log.d(TAG, "Adding breaker at:" + (breakerCount()+1));
            this.breakerList.add(this.breakerCount(), new Breaker(this.breakerCount()+1, updatedBreaker.getBreakerDescription(), updatedBreaker.getAmperage(), Breaker.DoublePoleBottom));
            numberOfBreakers++;
        }
        // Simply update the bottom of Double Pole
        else {
         Breaker bottomDoublePole = this.breakerList.get(breakerIndex+2);
         bottomDoublePole.setBreakerType(Breaker.DoublePoleBottom);
         bottomDoublePole.setBreakerDescription(updatedBreaker.getBreakerDescription());
         bottomDoublePole.setAmperage(updatedBreaker.getAmperage());
        }
    }
 // Updated Breaker is bottom of Double-Pole
 else if(updatedBreaker.getBreakerType().equals(Breaker.DoublePoleBottom)) {
 Log.d(TAG, "Updated Breaker is bottom of Double Pole");
 //Copy Changes to Upper Part of Double-Pole
 Breaker topDoublePole = this.breakerList.get(breakerIndex-2);
 topDoublePole.setBreakerDescription(updatedBreaker.getBreakerDescription());
 topDoublePole.setAmperage(updatedBreaker.getAmperage());
 }
 // Updated Breaker is Single-Pole
 else {
 Log.d(TAG, "Updated Breaker is top of Single Pole");
 //Set above breaker to single pole
 if(breakerIndex > 1) {
 Breaker aboveBreaker = this.getBreakerList().get(breakerIndex-2);
 if(aboveBreaker.getBreakerType().equals(Breaker.DoublePole)) {
 aboveBreaker.setBreakerType(Breaker.SinglePole);
 }
 }
 //Set below breaker to single pole
 if(breakerIndex+2 < this.breakerCount()) {
 Breaker belowBreaker = this.getBreakerList().get(breakerIndex+2);
 if(belowBreaker.getBreakerType().equals(Breaker.DoublePoleBottom)) {
 belowBreaker.setBreakerType(Breaker.SinglePole);
 }
 }
 }
 return this;
 }
 public Panel addBreaker(Breaker newBreaker) {
 this.breakerList.add(newBreaker);
 numberOfBreakers++;
 
 if(newBreaker.getBreakerType().equals(Breaker.DoublePole)) {
 this.breakerList.add(new Breaker(this.breakerCount()+1, ""));
 numberOfBreakers++;
 this.breakerList.add(new Breaker(this.breakerCount()+1, newBreaker.getBreakerDescription(), newBreaker.getAmperage(), Breaker.DoublePoleBottom));
 numberOfBreakers++;
 }
 return this;
 }
 
 //MARK:- StringDefs
 //PanelAmperageConstants
 public static final String OneHundred = "100A";
 public static final String TwoHundred = "200A";
 
 //MainPanelAmperage Constants
 public static final String FourHundred = "400A";
 public static final String SixHundred = "600A";
 public static final String EightHundred = "800A";
 public static final String OneThousand = "1000A";
 public static final String OneThousandTwoHundred = "1200A";
 
 //SubPanelAmperageConstants
 public static final String OneHundredTwentyFive = "125A";
 public static final String OneHundredFifty = "150A";

 
 //PanelManufacturer Constants
 public static final String BRYANT = "Bryant";
 public static final String GENERAL_ELECTRIC = "General Electric";
 public static final String MURRY = "Murry";
 public static final String SQUARE_D_HOMELINE = "Square D Homeline";
 public static final String SQUARE_D_QO_SERIES = "Square D QO";
 public static final String SIEMENS_ITE = "Siemens ITE";
 public static final String WADSWORTH = "Wadsworth";
 public static final String WESTINGHOUSE = "Westinghouse";
 public static final String OTHER = "Other";
 }
 */
