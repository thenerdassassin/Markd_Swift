//
//  Protocol.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/10/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase

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

protocol LoginHandler {
    func loginSuccessHandler(_ user:User)
    func loginFailureHandler(_ error:Error)
}

public protocol OnGetDataListener {
    func onStart()
    func onSuccess()
    func onFailure(_ error: Error)
}
public protocol OnGetContractorListener {
    func onFinished(contractor: Contractor?)
    func onFailure(_ error: Error)
}

extension CustomStringConvertible {
    public var description: String {
        var description = "\n***** \(type(of: self)) ***** \n "
        let selfMirror = Mirror(reflecting:self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "     \(propertyName) : \(child.value) \n "
            }
        }
        return description
    }
}

