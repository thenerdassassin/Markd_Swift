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
    private var interiorPaintSurfaces: [PaintSurface]?
    private var exteriorPaintSurfaces: [PaintSurface]?
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
                    plumbingServices!.sort()
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
                    hvacServices!.sort()
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
                    electricalServices!.sort()
                }
            }
        }
        
        if let interiorPaintArray = dictionary["interiorPaintSurfaces"] as? NSArray {
            interiorPaintSurfaces = [PaintSurface]()
            for surface in interiorPaintArray {
                if let surfaceDictionary = surface as? Dictionary<String, AnyObject> {
                    interiorPaintSurfaces!.append(PaintSurface(surfaceDictionary))
                    interiorPaintSurfaces!.sort()
                }
            }
        }
        if let exteriorPaintArray = dictionary["exteriorPaintSurfaces"] as? NSArray {
            exteriorPaintSurfaces = [PaintSurface]()
            for surface in exteriorPaintArray {
                if let surfaceDictionary = surface as? Dictionary<String, AnyObject> {
                    exteriorPaintSurfaces!.append(PaintSurface(surfaceDictionary))
                    exteriorPaintSurfaces!.sort()
                }
            }
        }
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
    func updatePlumbingService(_ service:ContractorService, _  number:Int) -> Customer {
        if self.plumbingServices != nil {
            if(number == -1) {
                self.plumbingServices!.append(service)
            } else {
                self.plumbingServices![number] = service
            }
            return self
        } else {
            self.plumbingServices = [ContractorService]()
            self.plumbingServices!.append(service)
            return self
        }
    }
    func removePlumbingService(_ index:Int) -> Customer {
        guard self.plumbingServices != nil else {
            return self
        }
        self.plumbingServices!.remove(at: index)
        return self
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
    func updateHvacService(_ service:ContractorService, _  number:Int) -> Customer {
        if let _ = hvacServices {
            if(number == -1) {
                self.hvacServices!.append(service)
            } else {
                self.hvacServices![number] = service
            }
            return self
        } else {
            self.hvacServices = [ContractorService]()
            self.hvacServices!.append(service)
            return self
        }
    }
    func removeHvacService(_ index:Int) -> Customer {
        guard self.hvacServices != nil else {
            return self
        }
        self.hvacServices!.remove(at: index)
        return self
    }
    
    //Mark:- Electrical
    func getElectrician() -> String? {
        if(StringUtilities.isNilOrEmpty(electricianReference)) {
            return nil
        }
        return electricianReference
    }
        
    func getElectricalServices() -> [ContractorService]? {
        return electricalServices
    }
    func updateElectricalService(_ service:ContractorService, _  number:Int) -> Customer {
        if let _ = electricalServices {
            if(number == -1) {
                self.electricalServices!.append(service)
            } else {
                self.electricalServices![number] = service
            }
            return self
        } else {
            self.electricalServices = [ContractorService]()
            self.electricalServices!.append(service)
            return self
        }
    }
    func removeElectricalService(_ index:Int) -> Customer {
        guard self.electricalServices != nil else {
            return self
        }
        self.electricalServices!.remove(at: index)
        return self
    }
    
    //Mark:- Painting
    func getInteriorPaintSurfaces() -> [PaintSurface]? {
        return interiorPaintSurfaces
    }
    func getExteriorPaintSurfaces() -> [PaintSurface]? {
        return exteriorPaintSurfaces
    }
    func getPainter() -> String? {
        if(StringUtilities.isNilOrEmpty(painterReference)) {
            return nil
        }
        return painterReference
    }
    func updatePaintSurface(_ surface:PaintSurface, _  number:Int, isInterior:Bool) -> Customer {
        if(isInterior) {
            if let _ = interiorPaintSurfaces {
                if(number == -1) {
                    self.interiorPaintSurfaces!.append(surface)
                } else {
                    self.interiorPaintSurfaces![number] = surface
                }
                return self
            } else {
                self.interiorPaintSurfaces = [PaintSurface]()
                self.interiorPaintSurfaces!.append(surface)
                return self
            }
        } else {
            if let _ = exteriorPaintSurfaces {
                if(number == -1) {
                    self.exteriorPaintSurfaces!.append(surface)
                } else {
                    self.exteriorPaintSurfaces![number] = surface
                }
                return self
            } else {
                self.exteriorPaintSurfaces = [PaintSurface]()
                self.exteriorPaintSurfaces!.append(surface)
                return self
            }
        }
    }
    func deletePaintSurface(_ index:Int, fromInteriorSurfaces:Bool) -> Customer {
        if (fromInteriorSurfaces) {
            guard self.interiorPaintSurfaces != nil else {
                return self
            }
            self.interiorPaintSurfaces!.remove(at: index)
            return self
        } else {
            guard self.exteriorPaintSurfaces != nil else {
                return self
            }
            self.exteriorPaintSurfaces!.remove(at: index)
            return self
        }
    }
    
    //Mark:- Services
    public func update(_ service:ContractorService, _  number:Int, of type:String) -> Customer {
        if type == "Plumbing" {
            return updatePlumbingService(service, number)
        } else if type == "Hvac" {
            return updateHvacService(service, number)
        } else if type == "Electrical" {
            return updateElectricalService(service, number)
        }
        return self
    }
    public func deleteService(_ number:Int, of type:String) -> Customer{
        if type == "Plumbing" {
            return removePlumbingService(number)
        } else if type == "Hvac" {
            return removeHvacService(number)
        } else if type == "Electrical" {
            return removeElectricalService(number)
        }
        return self
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
        if let plumbingServices = plumbingServices?.sorted() {
            var plumbingArray = NSArray()
            for service in plumbingServices {
                plumbingArray = plumbingArray.adding(service.toDictionary()) as NSArray
            }
            dictionary["plumbingServices"] = plumbingArray
        }
        
        dictionary["airHandler"] = self.airHandler?.toDictionary() as AnyObject
        dictionary["compressor"] = self.compressor?.toDictionary() as AnyObject
        dictionary["hvactechnicianReference"] = self.hvactechnicianReference as AnyObject
        if let hvacServices = hvacServices?.sorted() {
            var hvacArray = NSArray()
            for service in hvacServices {
                hvacArray = hvacArray.adding(service.toDictionary()) as NSArray
            }
            dictionary["hvacServices"] = hvacArray
        }
        
        //TODO: panels
        dictionary["electricianReference"] = self.electricianReference as AnyObject
        if let electricalServices = electricalServices?.sorted() {
            var electricalArray = NSArray()
            for service in electricalServices {
                electricalArray = electricalArray.adding(service.toDictionary()) as NSArray
            }
            dictionary["electricalServices"] = electricalArray
        }
        
        if let interiorPaintSurfaces = interiorPaintSurfaces?.sorted() {
            var interiorPaintSurfacesArray = NSArray()
            for surface in interiorPaintSurfaces {
                interiorPaintSurfacesArray = interiorPaintSurfacesArray.adding(surface.toDictionary()) as NSArray
            }
            dictionary["interiorPaintSurfaces"] = interiorPaintSurfacesArray
        }
        if let exteriorPaintSurfaces = exteriorPaintSurfaces?.sorted() {
            var exteriorPaintSurfaceArray = NSArray()
            for surface in exteriorPaintSurfaces {
                exteriorPaintSurfaceArray = exteriorPaintSurfaceArray.adding(surface.toDictionary()) as NSArray
            }
            dictionary["exteriorPaintSurfaces"] = exteriorPaintSurfaceArray
        }
        dictionary["painterReference"] = self.painterReference as AnyObject
        dictionary["userType"] = self.userType as AnyObject
        
        return dictionary
    }
}
