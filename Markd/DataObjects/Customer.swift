//
//  Customer.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import Firebase

public class Customer:CustomStringConvertible {
    func NEED_TO_ADD_ANDROID_METHODS😤() {
        var NEED_TO_ADD_ANDROID_METHODS😤:AnyObject?
    }
    public final let userType = "customer"
    
    //For Home Page
    private var namePrefix: String
    private var firstName: String
    private var lastName: String
    private var maritalStatus: String
    private var address: Address?
    private var home: Home?
    private var architectReference: String
    private var builderReference: String
    private var realtorReference: String
    private var homeImageFileName: String
    
    //For Plumbing Page
    private var hotWater: HotWater?
    private var boiler: Boiler?
    private var plumberReference: String
    private var plumbingServices: [ContractorService]?
    
    //For HVAC Page
    private var airHandler: AirHandler?
    private var compressor: Compressor?
    private var hvactechnicianReference: String
    private var hvacServices: [ContractorService]?
    
    //For Electrical Page
    //TODO: private List<Panel> panels
    private var electricianReference: String
    private var electricalServices: [ContractorService]?
    
    //For Painting Page
    //TODO: private List<PaintSurface> interiorPaintSurfaces
    //TODO: private List<PaintSurface> exteriorPaintSurfaces
    private var painterReference: String
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.namePrefix = dictionary["namePrefix"] != nil ? dictionary["namePrefix"] as! String: ""
        self.firstName = dictionary["firstName"] != nil ? dictionary["firstName"] as! String: ""
        self.lastName = dictionary["lastName"] != nil ? dictionary["lastName"] as! String: ""
        self.maritalStatus = dictionary["maritalStatus"] != nil ? dictionary["maritalStatus"] as! String: ""
        if let addressDictionary = dictionary["address"] as? Dictionary<String, AnyObject> {
            self.address = Address(addressDictionary)
        }
        if let homeDictionary = dictionary["home"] as? Dictionary<String, AnyObject> {
            self.home = Home(homeDictionary)
        }
        self.architectReference = dictionary["architectReference"] != nil ? dictionary["architectReference"] as! String: ""
        self.builderReference = dictionary["builderReference"] != nil ? dictionary["builderReference"] as! String: ""
        self.realtorReference = dictionary["realtorReference"] != nil ? dictionary["realtorReference"] as! String: ""
        self.homeImageFileName = dictionary["homeImageFileName"] != nil ? dictionary["homeImageFileName"] as! String: ""
        
        if let hotWaterDictionary = dictionary["hotWater"] as? Dictionary<String, AnyObject> {
            self.hotWater = HotWater(hotWaterDictionary)
        }
        if let boilerDictionary = dictionary["boiler"] as? Dictionary<String, AnyObject> {
            self.boiler = Boiler(boilerDictionary)
        }
        self.plumberReference = dictionary["plumberReference"] != nil ? dictionary["plumberReference"] as! String: ""
        if let plumbingArray = dictionary["plumbingServices"] as? NSArray {
            plumbingServices = [ContractorService]()
            for service in plumbingArray {
                if let serviceDictionary = service as? Dictionary<String, AnyObject> {
                    plumbingServices!.append(ContractorService(serviceDictionary))
                }
            }
        }
        
        if let airHandlerDictionary = dictionary["airHandler"] as? Dictionary<String, AnyObject> {
            self.airHandler = AirHandler(airHandlerDictionary)
        }
        if let compressorDictionary = dictionary["compressor"] as? Dictionary<String, AnyObject> {
            self.compressor = Compressor(compressorDictionary)
        }
        self.hvactechnicianReference = dictionary["hvactechnicianReference"] != nil ? dictionary["hvactechnicianReference"] as! String: ""
        if let hvacArray = dictionary["hvacServices"] as? NSArray {
            hvacServices = [ContractorService]()
            for service in hvacArray {
                if let serviceDictionary = service as? Dictionary<String, AnyObject> {
                    hvacServices!.append(ContractorService(serviceDictionary))
                }
            }
        }
        
        //TODO: panels
        self.electricianReference = dictionary["electricianReference"] != nil ? dictionary["electricianReference"] as! String: ""
        if let electricalArray = dictionary["electricalServices"] as? NSArray {
            electricalServices = [ContractorService]()
            for service in electricalArray {
                if let serviceDictionary = service as? Dictionary<String, AnyObject> {
                    electricalServices!.append(ContractorService(serviceDictionary))
                }
            }
        }
        
        //TODO: interiorPaintSurfaces
        //TODO: exteriorPaintSurfaces
        self.painterReference = dictionary["painterReference"] != nil ? dictionary["painterReference"] as! String: ""
    }
    
    //:- Home Page
    func getNamePrefix() -> String {
        return namePrefix;
    }
    func setNamePrefix(_ namePrefix: String) {
        self.namePrefix = namePrefix;
    }
    func getFirstName() -> String {
        return firstName;
    }
    func setFirstName(_ firstName: String) {
        self.firstName = firstName;
    }
    func getLastName() -> String {
        return lastName;
    }
    func setLastName(_ lastName: String) {
        self.lastName = lastName;
    }
    func getMaritalStatus() -> String{
        return maritalStatus;
    }
    func setMaritalStatus(_ maritalStatus: String) {
        self.maritalStatus = maritalStatus;
    }
    func getName() -> String {
        return StringUtilities.getFormattedName(withPrefix: namePrefix, withFirstName: firstName, withLastName: lastName, withMaritalStatus: maritalStatus)
    }
    func getHome() -> Home? {
        return home;
    }
    func setHome(_ home: Home?) {
        self.home = home;
    }
    func getAddress() -> Address? {
        return address;
    }
    func setAddress(_ address: Address?) {
        self.address = address;
    }
    func getArchitectReference() -> String {
        return architectReference;
    }
    func setArchitect(_ architect: String) {
        self.architectReference = architect;
    }
    func getBuilder() -> String {
        return builderReference;
    }
    func setBuilder(_ builder: String) {
        self.builderReference = builder;
    }
    func getRealtor() -> String {
        return realtorReference;
    }
    func setRealtor(_ realtor: String) {
        self.realtorReference = realtor;
    }
    func getHomeImageFileName() -> String{
        return homeImageFileName;
    }
    func setHomeImageFileName() -> Customer {
        self.homeImageFileName = UUID.init().uuidString
        return self;
    }
    
    //Mark:- Plumbing Page
    func getHotWater() -> HotWater? {
        return hotWater
    }
    func setHotWater(to hotWater:HotWater) -> Customer {
        self.hotWater = hotWater
        return self
    }
    func getBoiler() -> Boiler? {
        return boiler
    }
    func setBoiler(to boiler:Boiler) -> Customer {
        self.boiler = boiler
        return self
    }
    func getPlumber() -> String? {
        if(StringUtilities.isNilOrEmpty(plumberReference)) {
            return nil
        }
        return plumberReference
    }
    func getPlumbingServices() -> [ContractorService]? {
        return plumbingServices
    }
    
    //Mark:- HVAC
    func getAirHandler() -> AirHandler? {
        return airHandler
    }
    func setAirHandler(to airHandler:AirHandler) -> Customer {
        self.airHandler = airHandler
        return self
    }
    func getCompressor() -> Compressor? {
        return compressor
    }
    func setCompressor(to compressor:Compressor) -> Customer {
        self.compressor = compressor
        return self
    }
    func getHvacTechnician() -> String? {
        if(StringUtilities.isNilOrEmpty(hvactechnicianReference)) {
            return nil
        }
        return hvactechnicianReference
    }
    func getHvacServices() -> [ContractorService]? {
        return hvacServices
    }
    
    //Mar:- Electrical
    func getElectricalServices() -> [ContractorService]? {
        return electricalServices
    }
    var TODO_Implement_All_Setters_And_Helpers🤬:AnyObject?
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        
        dictionary["namePrefix"] = self.namePrefix as AnyObject
        dictionary["firstName"] = self.firstName as AnyObject
        dictionary["lastName"] = self.lastName as AnyObject
        dictionary["maritalStatus"] = self.maritalStatus as AnyObject
        dictionary["address"] = self.address?.toDictionary() as AnyObject
        dictionary["home"] = self.home?.toDictionary() as AnyObject
        dictionary["architectReference"] = self.architectReference as AnyObject
        dictionary["builderReference"] = self.builderReference as AnyObject
        dictionary["realtorReference"] = self.realtorReference as AnyObject
        dictionary["homeImageFileName"] = self.homeImageFileName as AnyObject
        
        dictionary["hotWater"] = self.hotWater?.toDictionary() as AnyObject
        dictionary["boiler"] = self.boiler?.toDictionary() as AnyObject
        dictionary["plumberReference"] = self.plumberReference as AnyObject
        if let plumbingServices = plumbingServices {
            let plumbingArray = NSArray()
            for service in plumbingServices {
                plumbingArray.adding(service.toDictionary())
            }
            dictionary["plumbingServices"] = plumbingArray
        }
        
        dictionary["airHandler"] = self.airHandler?.toDictionary() as AnyObject
        dictionary["compressor"] = self.compressor?.toDictionary() as AnyObject
        dictionary["hvactechnicianReference"] = self.hvactechnicianReference as AnyObject
        if let hvacServices = hvacServices {
            let hvacArray = NSArray()
            for service in hvacServices {
                hvacArray.adding(service.toDictionary())
            }
            dictionary["hvacServices"] = hvacArray
        }
        
        //TODO: panels
        dictionary["electricianReference"] = self.electricianReference as AnyObject
        if let electricalServices = electricalServices {
            let electricalArray = NSArray()
            for service in electricalServices {
                electricalArray.adding(service.toDictionary())
            }
            dictionary["electricalServices"] = electricalArray
        }
        
        //TODO: interiorPaintSurfaces
        //TODO: exteriorPaintSurfaces
        dictionary["painterReference"] = self.painterReference as AnyObject
        
        return dictionary
    }
}
