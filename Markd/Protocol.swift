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
extension LoginHandler {
    func storeToken(_ user:User) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let deviceToken = appDelegate.token, let fcmToken = Messaging.messaging().fcmToken {
            let reference = Database.database().reference().child("tokens").child(user.uid).child(deviceToken)
            reference.setValue(fcmToken)
            print("-----------\nSaving user \(user.uid) on device \(deviceToken) with token \(fcmToken)------------------\n")
        }
    }
}

public protocol ApplianceViewController {
    var customerData: TempCustomerData? { get set }
}
public protocol OnGetDataListener {
    func onStart()
    func onSuccess()
    func onFailure(_ error: Error)
}
public protocol OnGetContractorListener {
    func onFinished(contractor: Contractor?, at reference: String?)
    func onFailure(_ error: Error)
}
public protocol PurchaseHandler {
    func purchase(_: UIAlertAction) -> Void
    func purchase(wasSuccessful:Bool)
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

