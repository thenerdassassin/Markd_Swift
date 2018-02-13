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
    case oneHundred = 0
    case twoHundred = 1
    case fourHundred = 2
    case sixHundred = 3
    case eightHundred = 4
    case oneThousand = 5
    case oneThousandTwoHundred = 6
    
    static var count: Int { return MainPanelAmperage.oneThousandTwoHundred.hashValue + 1 }
    
    var description: String {
        switch self {
        case .oneHundred: return "100A"
        case .twoHundred: return "200A"
        case .fourHundred: return "400A"
        case .sixHundred: return "600A"
        case .eightHundred: return "800A"
        case .oneThousand: return "1000A"
        case .oneThousandTwoHundred: return "1200A"
        }
    }
}

enum SubPanelAmperage: Int, CustomStringConvertible, PanelAmperage {
    case oneHundred = 0
    case oneHundredTwentyFive = 1
    case oneHundredFifty = 2
    case twoHundred = 3
    
    static var count: Int { return SubPanelAmperage.twoHundred.hashValue + 1 }
    
    var description: String {
        switch self {
        case .oneHundred: return "100A"
        case .oneHundredTwentyFive: return "125A"
        case .oneHundredFifty: return "150A"
        case .twoHundred: return "200A"
        }
    }
}

enum PanelManufacturer: Int, CustomStringConvertible {
    case bryant = 0
    case generalElectric = 1
    case murry = 2
    case squareDHomline = 3
    case squareDQOSeries = 4
    case siemensITE = 5
    case wadsworth = 6
    case westinghouse = 7
    case unknown = 8
    
    static var count: Int { return PanelManufacturer.unknown.hashValue + 1 }
    
    var description: String {
        switch self {
        case .bryant: return "Bryant"
        case .generalElectric: return "General Electric"
        case .murry: return "Murry"
        case .squareDHomline: return "Square D Homline"
        case .squareDQOSeries: return "Square D QO"
        case .siemensITE: return "Siemens ITE"
        case .wadsworth: return "Wadsworth"
        case .westinghouse: return "Westinghouse"
        case .unknown: return "Unknown"
        }
    }
}

enum BreakerAmperage: Int, CustomStringConvertible {
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
    static var count: Int { return BreakerAmperage.twoHundred.hashValue + 1 }
    
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
        case .doublePoleBottom: return "Double-Pole"
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
        self.init(isMainPanel: isMainPanel, amperage: amperage, breakers: breakers, manufacturer: .unknown)
    }
    
    convenience init(amperage: PanelAmperage, breakers:[Breaker]) {
        self.init(isMainPanel: true, amperage: amperage, breakers: breakers, manufacturer: .unknown)
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
        let areaCode = phone.substring(with: NSRange(location: 0, length: 3))
        let threeDigit = phone.substring(with: NSRange(location: 3, length: 3))
        let fourDigit = phone.substring(with: NSRange(location: 6, length: 4))
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
        self.init(number:number, breakerDescription:breakerDescription, amperage: .twenty, breakerType:breakerType)
    }
    
    convenience init(number:Int, breakerDescription:String) {
        self.init(number:number, breakerDescription:breakerDescription, amperage: .twenty, breakerType:.singlePole)
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
