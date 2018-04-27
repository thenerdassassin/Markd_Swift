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
    private var customer: Customer?
    private var customerId: String?
    private var userReference: DatabaseReference?
    private var listener: OnGetDataListener?
    private var handle: UInt?
    
    public func printCustomer() {
        if let customer = customer {
            print(customer.description)
        }
    }
    public init(_ getDataListener: OnGetDataListener?) {
        TempCustomerData.database.keepSynced(true)
        self.customerId = FirebaseAuthentication.sharedInstance.getCurrentUser()?.uid
        self.listener = getDataListener
        if let customerId = customerId {
            userReference = TempCustomerData.database.child(customerId)
            if let userReference = userReference {
                handle = userReference.observe(DataEventType.value, with: customerSuccessListener, withCancel: customerCancelListener)
            } else {
                print("No userReference")
            }
        } else {
            self.userReference = nil
            customer = nil
            if let currentView = UIApplication.shared.keyWindow?.rootViewController {
                AlertControllerUtilities.somethingWentWrong(with: currentView)
            }
        }
    }
    
    public func removeListeners() {
        if let userReference = userReference, let handle = handle {
            userReference.removeObserver(withHandle: handle)
        }
    }
    
    private func customerSuccessListener(_ snapshot:DataSnapshot) {
        if let dictionary = snapshot.value as? [String : AnyObject] {
            customer = Customer(dictionary)
            if let listener = self.listener {
                listener.onSuccess()
            } else {
                if let currentView = UIApplication.shared.keyWindow?.rootViewController {
                    AlertControllerUtilities.somethingWentWrong(with: currentView)
                }
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
        return customer
    }
    
    private func updateCustomer(to customer: Customer?) {
        if let userReference = userReference, let customer = customer {
            userReference.setValue(customer.toDictionary())
        } else {
            if let currentView = UIApplication.shared.keyWindow?.rootViewController {
                AlertControllerUtilities.somethingWentWrong(with: currentView)
            }
        }
    }
    
    //Mark:- Home Page
    public func getName() -> String {
        if let customer = customer {
            return customer.getName()
        } else {
            return ""
        }
    }
    public func getFormattedAddress() -> String? {
        if let _ = customer?.getHome() {
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
        if let home = customer?.getHome() {
            let middot:String = "\u{00B7}";
            let bedrooms: Double = home.getBedrooms();
            let bathrooms: Double = home.getBathrooms();
            return "\(NSNumber(value: bedrooms).stringValue) \(bedrooms == 1.0 ? "bedroom" : "bedrooms") \(middot) \(NSNumber(value: bathrooms).stringValue) \(bathrooms == 1.0 ? "bathroom" : "bathrooms")"
        } else {
            return nil
        }
    }
    public func getSquareFootageString() -> String? {
        if let home = customer?.getHome() {
            return "\(home.getSquareFootage()) square feet"
        } else {
            return nil
        }
    }
    public func getHomeImageFileName() -> String? {
        if let customer = customer, let customerId = customerId {
            return "homes/" + customerId + "/" + customer.getHomeImageFileName();
        } else {
            return nil
        }
    }
    public func setHomeImageFileName() -> String? {
        if let customer = customer {
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
    
    //Mark:- PlumbingPage
    public func getHotWater() -> HotWater? {
        return getCustomer()?.getHotWater()
    }
    public func updateHotWater(to hotWater:HotWater) {
         updateCustomer(to: getCustomer()?.setHotWater(to: hotWater))
    }
    public func getBoiler() -> Boiler? {
        return getCustomer()?.getBoiler()
    }
    public func updateBoiler(to boiler:Boiler) {
         updateCustomer(to: getCustomer()?.setBoiler(to: boiler))
    }
    public func getPlumber(plumberListener: OnGetContractorListener?) {
        guard let listener = plumberListener else {
            return
        }
        guard let customer = customer, let plumber = customer.getPlumber() else {
            print("There is no plumber")
            listener.onFinished(contractor: nil, at: nil)
            return
        }
        let plumberReference:DatabaseReference = TempCustomerData.database.child(plumber)
        plumberReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                listener.onFinished(contractor: Contractor(dictionary), at: plumber)
            }
        }) { (error) in
            listener.onFailure(error)
        }
    }
    public func getPlumberReference() -> String? {
        return getCustomer()?.getPlumber()
    }
    public func getPlumbingServices() {
        var TODO_ImplementGetPlumbingServices🤔:AnyObject?
    }
    
    //Mark:- HvacPage
    public func getAirHandler() -> AirHandler? {
        return getCustomer()?.getAirHandler()
    }
    public func updateAirHandler(to airHandler:AirHandler) {
        updateCustomer(to: getCustomer()?.setAirHandler(to: airHandler))
    }
    public func getCompressor() -> Compressor? {
        return getCustomer()?.getCompressor()
    }
    public func updateCompressor(to compressor:Compressor) {
         updateCustomer(to: getCustomer()?.setCompressor(to: compressor))
    }
    public func getHvacTechnician(hvacTechnicianListener: OnGetContractorListener?) {
        guard let listener = hvacTechnicianListener else {
            return
        }
        guard let customer = customer, let hvacTechnician = customer.getHvacTechnician() else {
            print("There is no hvac technician")
            listener.onFinished(contractor: nil, at: nil)
            return
        }
        let hvaeTechnicianReference:DatabaseReference = TempCustomerData.database.child(hvacTechnician)
        hvaeTechnicianReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                listener.onFinished(contractor: Contractor(dictionary), at:hvacTechnician)
            }
        }) { (error) in
            listener.onFailure(error)
        }
    }
    public func getHvactechnicianReference() -> String? {
        return getCustomer()?.getHvacTechnician()
    }
    public func getHvacServices() {
        var TODO_ImplementGetHvacServices🤔:AnyObject?
    }
        
    public func setAppliance(to newAppliance: Appliance) {
        if let hotWater = newAppliance as? HotWater {
            self.updateHotWater(to: hotWater)
        } else if let boiler = newAppliance as? Boiler {
            self.updateBoiler(to: boiler)
        } else if let airHandler = newAppliance as? AirHandler {
            self.updateAirHandler(to: airHandler)
        } else if let compressor = newAppliance as? Compressor {
            self.updateCompressor(to: compressor)
        } else {
            print("Appliance type does not match")
        }
    }
    func NEED_TO_ADD_ANDROID_METHODS😤() {
        var NEED_TO_ADD_ANDROID_METHODS😤:AnyObject?
        //TODO: addContractorListener, attachListener, removeListener, getUid
        //TODO: electricalPage
        //TODO: paintingPage
        //TODO: services
        //TODO: settingsPage
        //TODO: makeCustomer
    }
}

