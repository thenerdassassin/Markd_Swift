//
//  PanelAmerage.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/19/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public enum MainPanelAmperage: Int, CustomStringConvertible, PanelAmperage {
    case oneHundred = 0
    case twoHundred = 1
    case fourHundred = 2
    case sixHundred = 3
    case eightHundred = 4
    case oneThousand = 5
    case oneThousandTwoHundred = 6
    
    static var count: Int { return MainPanelAmperage.oneThousandTwoHundred.hashValue + 1 }
    
    public var description: String {
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
    
    static func getRawValue(from amperage:String?) -> MainPanelAmperage {
        switch amperage {
        case "100A": return .oneHundred
        case "200A": return .twoHundred
        case "400A": return .fourHundred
        case "600A": return .sixHundred
        case "800A": return .eightHundred
        case "1000A": return .oneThousand
        case "1200A": return .oneThousandTwoHundred
        default: return .oneHundred
        }
    }
}

public enum SubPanelAmperage: Int, CustomStringConvertible, PanelAmperage {
    case oneHundred = 0
    case oneHundredTwentyFive = 1
    case oneHundredFifty = 2
    case twoHundred = 3
    
    static var count: Int { return SubPanelAmperage.twoHundred.hashValue + 1 }
    
    public var description: String {
        switch self {
        case .oneHundred: return "100A"
        case .oneHundredTwentyFive: return "125A"
        case .oneHundredFifty: return "150A"
        case .twoHundred: return "200A"
        }
    }
    
    static func getRawValue(from amperage:String?) -> SubPanelAmperage {
        switch amperage {
        case "100A": return .oneHundred
        case "125A": return .oneHundredTwentyFive
        case "150A": return .oneHundredFifty
        case "200A": return .twoHundred
        default: return .oneHundred
        }
    }
}
