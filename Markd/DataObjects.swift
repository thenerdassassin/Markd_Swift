//
//  DataObjects.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/5/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

//From: http://stackoverflow.com/questions/30025481/take-data-from-enum-to-show-on-uipickerview-swift
enum MainPanelAmperage: Int, CustomStringConvertible, PanelAmperage {
    case OneHundred = 0
    case TwoHundred = 1
    case FourHundred = 2
    case SixHundred = 3
    case EightHundred = 4
    case OneThousand = 5
    case OneThousandTwoHundred = 6
    
    static var count: Int { return MainPanelAmperage.OneThousandTwoHundred.hashValue + 1 }
    
    var description: String {
        switch self {
        case .OneHundred: return "100A"
        case .TwoHundred: return "200A"
        case .FourHundred: return "400A"
        case .SixHundred: return "600A"
        case .EightHundred: return "800A"
        case .OneThousand: return "1000A"
        case .OneThousandTwoHundred: return "1200A"
        }
    }
}

enum SubPanelAmperage: Int, CustomStringConvertible, PanelAmperage {
    case OneHundred = 0
    case OneHundredTwentyFive = 1
    case OneHundredFifty = 2
    case TwoHundred = 3
    
    static var count: Int { return SubPanelAmperage.TwoHundred.hashValue + 1 }
    
    var description: String {
        switch self {
        case .OneHundred: return "100A"
        case .OneHundredTwentyFive: return "125A"
        case .OneHundredFifty: return "150A"
        case .TwoHundred: return "200A"
        }
    }
}

enum PanelManufacturer: Int, CustomStringConvertible {
    case Bryant = 0
    case GeneralElectric = 1
    case Murry = 2
    case SquareDHomline = 3
    case SquareDQOSeries = 4
    case SiemensITE = 5
    case Wadsworth = 6
    case Westinghouse = 7
    case Unknown = 8
    
    static var count: Int { return PanelManufacturer.Unknown.hashValue + 1 }
    
    var description: String {
        switch self {
        case .Bryant: return "Bryant"
        case .GeneralElectric: return "General Electric"
        case .Murry: return "Murry"
        case .SquareDHomline: return "Square D Homline"
        case .SquareDQOSeries: return "Square D QO"
        case .SiemensITE: return "Siemens ITE"
        case .Wadsworth: return "Wadsworth"
        case .Westinghouse: return "Westinghouse"
        case .Unknown: return "Unknown"
        }
    }
}

enum BreakerAmperage: Int, CustomStringConvertible {
    case Fifteen = 0
    case Twenty = 1
    case Thirty = 2
    case Fourty = 3
    case Fifty = 4
    case Sixty = 5
    case Seventy = 6
    case Eighty = 7
    case OneHundred = 8
    case OneHundredTwentyFive = 9
    case OneHundredFifty = 10
    case TwoHundred = 11
    
    //Note: Change Fifty to last case if adding more amperages
    static var count: Int { return BreakerAmperage.TwoHundred.hashValue + 1 }
    
    //Note: Add Descriptions when adding more amperages
    var description: String {
        switch self {
        case .Fifteen: return "15A"
        case .Twenty: return "20A"
        case .Thirty: return "30A"
        case .Fourty: return "40A"
        case .Fifty: return "50A"
        case .Sixty: return "60A"
        case .Seventy: return "70A"
        case .Eighty: return "80A"
        case .OneHundred: return "100A"
        case .OneHundredTwentyFive: return "125A"
        case .OneHundredFifty: return "150A"
        case .TwoHundred: return "200A"
        }
    }
}

enum BreakerType: Int, CustomStringConvertible {
    case SinglePole = 0
    case DoublePole = 1
    case DoublePoleBottom = 2
    
    //Number Shown to Public
    static var count: Int { return 2 } //Don't have Double Pole Bottom in Count
    
    //Note: Add Descriptions when adding more amperages
    var description: String {
        switch self {
        case .SinglePole: return "Single-Pole"
        case .DoublePole: return "Double-Pole"
        case .DoublePoleBottom: return "Double-Pole"
        }
    }
}

class Panel {
    var isMainPanel:Bool
    var amperage: PanelAmperage
    var breakers:[Breaker]
    var manufacturer: PanelManufacturer
    var panelTitle:String {
        get {
            var panelTitleString = ""
            if(isMainPanel) {
                panelTitleString += "Main Panel "
            } else {
                panelTitleString += "Sub Panel "
            }
            
            panelTitleString += "\(amperage)"
            
            return panelTitleString
        }
    }
    
    init(isMainPanel:Bool, amperage: PanelAmperage, breakers:[Breaker], manufacturer:PanelManufacturer) {
        self.amperage = amperage
        self.isMainPanel = isMainPanel
        self.breakers = breakers
        self.manufacturer = manufacturer
    }
    
    convenience init(isMainPanel:Bool, amperage: PanelAmperage, breakers:[Breaker]) {
        self.init(isMainPanel: isMainPanel, amperage: amperage, breakers: breakers, manufacturer: .Unknown)
    }
    
    convenience init(amperage: PanelAmperage, breakers:[Breaker]) {
        self.init(isMainPanel: true, amperage: amperage, breakers: breakers, manufacturer: .Unknown)
    }
}

class Electrician {
    var url:String
    var company:String
    var street:String
    var city:String
    var state:String
    var zip:String
    var logo:UIImage
    var phoneNumber:String
    
    init(url:String, company:String, street:String, city:String, state:String, zip:String, logo:UIImage, phoneNumber:String) {
        self.url = url
        self.company = company
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.logo = logo
        self.phoneNumber = phoneNumber
    }
    
    
    
    // Used: http://stackoverflow.com/questions/24044851/how-do-you-use-string-substringwithrange-or-how-do-ranges-work-in-swift
    func formattedPhone() -> String {
        let phone = phoneNumber as NSString
        let areaCode = phone.substringWithRange(NSRange(location: 0, length: 3))
        let threeDigit = phone.substringWithRange(NSRange(location: 3, length: 3))
        let fourDigit = phone.substringWithRange(NSRange(location: 6, length: 4))
        return "(\(areaCode)) \(threeDigit)-\(fourDigit)"
    }
}

class Breaker: Equatable {
    var number:Int
    var breakerDescription:String
    var amperage:BreakerAmperage
    var breakerType:BreakerType
    
    init(number:Int, breakerDescription:String, amperage: BreakerAmperage, breakerType:BreakerType) {
        self.number = number
        self.breakerDescription = breakerDescription
        self.breakerType = breakerType
        self.amperage = amperage
    }
    
    convenience init(number:Int, breakerDescription:String, breakerType:BreakerType) {
        self.init(number:number, breakerDescription:breakerDescription, amperage: .Twenty, breakerType:breakerType)
    }
    
    convenience init(number:Int, breakerDescription:String) {
        self.init(number:number, breakerDescription:breakerDescription, amperage: .Twenty, breakerType:.SinglePole)
    }
    
    
}

//from: http://nshipster.com/swift-comparison-protocols/
func ==(lhs: Breaker, rhs: Breaker) -> Bool {
    if(lhs.breakerDescription != rhs.breakerDescription) {
        return false
    }
    
    if(lhs.number != rhs.number) {
        return false
    }
    
    if(lhs.breakerType != rhs.breakerType) {
        return false
    }
    
    return true
}