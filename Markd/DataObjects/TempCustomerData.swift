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
    public init(_ getDataListener: OnGetDataListener?, create customer:Customer, at id: String) {
        TempCustomerData.database.keepSynced(true)
        self.customerId = id
        self.listener = getDataListener
        userReference = TempCustomerData.database.child(customerId!)
        updateCustomer(to: customer)
        handle = userReference!.observe(DataEventType.value, with: customerSuccessListener, withCancel: customerCancelListener)
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
    
    public func getUid() -> String? {
        return self.customerId
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
    public static func getUserDatabase() -> DatabaseReference { return database }
    
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
    public func getPlumbingServices() -> [ContractorService]? {
        return getCustomer()?.getPlumbingServices()
    }
    public func updateContractor(of type: String, to reference: String) {
        switch type {
        case "Plumber":
            updateCustomer(to: getCustomer()?.setPlumber(to: reference))
        case "Hvac":
            updateCustomer(to: getCustomer()?.setHvacTechnician(to: reference))
        case "Electrician":
            updateCustomer(to: getCustomer()?.setElectrician(to: reference))
        case "Painter":
            updateCustomer(to: getCustomer()?.setPainter(to: reference))
        default:
            print("No \(type) of contractor")
        }
        
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
        let hvacTechnicianReference:DatabaseReference = TempCustomerData.database.child(hvacTechnician)
        hvacTechnicianReference.observeSingleEvent(of: .value, with: { (snapshot) in
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
    public func getHvacServices() -> [ContractorService]? {
        return getCustomer()?.getHvacServices()
    }
    
    //Mark:- ElectricalPage
    public func getPanels() -> [Panel]? {
        return getCustomer()?.getPanels()
    }
    public func updatePanel(at index: Int, to updatedPanel:Panel) {
       updateCustomer(to: getCustomer()?.updatePanel(updatedPanel, index))
    }
    public func removeElectricalPanel(at index:Int) {
        updateCustomer(to: getCustomer()?.deletePanel(index))
    }
    public func getElectricalServices() -> [ContractorService]? {
        return getCustomer()?.getElectricalServices()
    }
    public func getElectrician(electricianListener: OnGetContractorListener?) {
        guard let listener = electricianListener else {
            return
        }
        guard let customer = customer, let electrician = customer.getElectrician() else {
            print("There is no electrician")
            listener.onFinished(contractor: nil, at: nil)
            return
        }
        let electricianReference:DatabaseReference = TempCustomerData.database.child(electrician)
        electricianReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                listener.onFinished(contractor: Contractor(dictionary), at:electrician)
            }
        }) { (error) in
            listener.onFailure(error)
        }
    }
    
    //Mark:- PaintingPage
    public func getInteriorPaintSurfaces() -> [PaintSurface]? {
        return getCustomer()?.getInteriorPaintSurfaces()
    }
    public func getExteriorPaintSurfaces() -> [PaintSurface]? {
        return getCustomer()?.getExteriorPaintSurfaces()
    }
    public func removePaintSurface(at index:Int, fromInterior isInterior:Bool) {
        updateCustomer(to: getCustomer()?.deletePaintSurface(index, fromInteriorSurfaces: isInterior))
    }
    public func updatePaintSurface(at index: Int, fromInterior isInterior:Bool, to updatedSurface:PaintSurface) {
        updateCustomer(to: getCustomer()?.updatePaintSurface(updatedSurface, index, isInterior: isInterior))
    }
    public func getPainter(painterListener: OnGetContractorListener?) {
        guard let listener = painterListener else {
            return
        }
        guard let customer = customer, let painter = customer.getPainter() else {
            print("There is no painter")
            listener.onFinished(contractor: nil, at: nil)
            return
        }
        let painterReference:DatabaseReference = TempCustomerData.database.child(painter)
        painterReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                listener.onFinished(contractor: Contractor(dictionary), at:painter)
            }
        }) { (error) in
            listener.onFailure(error)
        }
    }
    
    //Mark:- Services
    public func update(_ service:ContractorService, _  number:Int, of type:String) {
        updateCustomer(to: getCustomer()?.update(service, number, of:type))
    }
    public func removeService(_ number:Int, of type:String) {
        updateCustomer(to: getCustomer()?.deleteService(number, of:type))
    }
    
    //Mark:- Settings
    public func getTitle() -> String?{
        return getCustomer()?.getNamePrefix()
    }
    public func getFirstName() -> String? {
        return getCustomer()?.getFirstName()
    }
    public func getLastName() -> String? {
        return getCustomer()?.getLastName()
    }
    public func getMaritalStatus() -> String? {
        return getCustomer()?.getMaritalStatus()
    }
    public func updateHome(to updatedHome: Home) {
        updateCustomer(to: getCustomer()?.setHome(updatedHome))
    }
    public func updateAddress(to updateAddress: Address) {
        updateCustomer(to: getCustomer()?.setAddress(updateAddress))
    }
    public func updateName(title prefix: String, with updatedFirstName: String, and updatedLastName: String) {
        if let customer = getCustomer() {
            customer.setNamePrefix(prefix)
            customer.setFirstName(updatedFirstName)
            customer.setLastName(updatedLastName)
            updateCustomer(to: customer)
        }
    }
    public func updateMaritalStatus(to newMaritalStatus:String) {
        updateCustomer(to: getCustomer()?.setMaritalStatus(newMaritalStatus))
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
}

