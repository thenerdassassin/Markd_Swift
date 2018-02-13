//
//  Protocol.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/10/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

protocol BreakerEdit {
    func editBreaker(breakerDescription:String, amperage:BreakerAmperage, breakerType:BreakerType)
    func addBreaker(breakerDescription:String, amperage:BreakerAmperage, breakerType:BreakerType)
}

protocol PanelEdit {
    func editPanel(_ newPanel:Panel)
}

//From: http://stackoverflow.com/questions/33191532/swift-enum-inheritance
protocol PanelAmperage {
    var description: String {get}
    var hashValue: Int {get}
    static var count: Int {get}
}

