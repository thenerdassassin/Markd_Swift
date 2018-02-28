//
//  TempCustomerData.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import Firebase

public class TempCustomerData {
    private static let database:DatabaseReference = Database.database().reference().child("users");
    private static var customer: Customer?
    private var customerId: String?
    private var userReference: DatabaseReference?
    private var listener: OnGetDataListener?
    
    public init(_ getDataListener: OnGetDataListener?) {
        self.customerId = FirebaseAuthentication.sharedInstance.getCurrentUser() != nil ? FirebaseAuthentication.sharedInstance.getCurrentUser()!.uid : nil
        self.listener = getDataListener
        if let customerId = customerId {
            userReference = TempCustomerData.database.child(customerId)
            userReference?.observe(DataEventType.value, with: customerSuccessListener, withCancel: customerCancelListener)
        } else {
            var NOT_IMPLEMENTED_🤪:AnyObject
            self.userReference = nil
            TempCustomerData.customer = nil
        }
    }
    
    private func customerSuccessListener(_ snapshot:DataSnapshot) {
        print("got data:", snapshot)
        if let dictionary = snapshot.value as? [String : AnyObject] {
            TempCustomerData.customer = Customer(dictionary)
            if let listener = self.listener {
                listener.onSuccess()
            } else {
                var NOT_IMPLEMENTED_🤪:AnyObject
            }
        }
    }
    
    private func customerCancelListener(_ error: Error) {
        print("got error", error)
        if let listener = self.listener {
            listener.onFailure(error)
        }
    }

    private func getCustomer() -> Customer? {
        return TempCustomerData.customer
    }
    
    private func updateCustomer(to customer: Customer) {
        if let userReference = userReference {
            userReference.setValue(customer)
        } else {
            var NOT_IMPLEMENTED_🤪:AnyObject
        }
    }
    
    //Mark:- Home Page
    public func getName() -> String {
        if let customer = TempCustomerData.customer {
            return customer.getName()
        } else {
            return ""
        }
    }
    public func getFormattedAddress() -> String? {
        if let _ = TempCustomerData.customer?.getHome() {
            if let street = getStreet(), let city = getCity(), let state = getState(), let zip = getZipcode() {
                return """
                \(street)
                \(city), \(state) \(zip)
                """
            }
        }
        return nil
    }
    public func getRoomInformation() -> String? {
        if let home = TempCustomerData.customer?.getHome() {
            let middot:String = "\u{00B7}";
            let bedrooms: Double = home.getBedrooms();
            let bathrooms: Double = home.getBathrooms();
            return "\(NSNumber(value: bedrooms).stringValue) \(bedrooms == 1.0 ? "bedroom" : "bedrooms") \(middot) \(NSNumber(value: bathrooms).stringValue) \(bathrooms == 1.0 ? "bathroom" : "bathrooms")"
        } else {
            return nil
        }
    }
    public func getSquareFootageString() -> String? {
        if let home = TempCustomerData.customer?.getHome() {
            return "\(home.getSquareFootage()) square feet"
        } else {
            return nil
        }
    }
    public func getHomeImageFileName() -> String? {
        if let customer = TempCustomerData.customer, let customerId = customerId {
            return "homes/" + customerId + "/" + customer.getHomeImageFileName();
        } else {
            return nil
        }
    }
    public func setHomeImageFileName() -> String? {
        if let customer = TempCustomerData.customer {
            updateCustomer(to: customer.setHomeImageFileName())
            return self.getHomeImageFileName()
        } else {
            return nil
        }
    }
    public func getStreet() -> String? {
        return getCustomer()?.getAddress()?.getStreet();
    }
    public func getCity() -> String? {
        return getCustomer()?.getAddress()?.getCity();
    }
    public func getState() -> String? {
    return getCustomer()?.getAddress()?.getState();
    }
    public func getZipcode() -> String? {
    return getCustomer()?.getAddress()?.getZipCode();
    }
    public func getBedrooms() -> String? {
        if let bedrooms = getCustomer()?.getHome()?.getBedrooms() {
            return "\(bedrooms)"
        }
        return nil
    }
    public func getBathrooms() -> String? {
        if let bathrooms = getCustomer()?.getHome()?.getBathrooms() {
            return "\(bathrooms)"
        }
        return nil
    }
    public func getSquareFootage() -> String? {
        if let squareFootage = getCustomer()?.getHome()?.getSquareFootage() {
            return "\(squareFootage)"
        }
        return nil
    }
    
    func NEED_TO_ADD_ANDROID_METHODS😤() {
        var NEED_TO_ADD_ANDROID_METHODS😤:AnyObject?
        //TODO: addContractorListener, attachListener, removeListener, getUid
        //TODO: plumbingPage
        //TODO: hvacPage
        //TODO: electricalPage
        //TODO: paintingPage
        //TODO: services
        //TODO: settingsPage
        //TODO: makeCustomer
    }
}

