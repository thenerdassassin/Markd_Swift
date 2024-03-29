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
    public final let userType = "customer"
    public var customerId:String?
    
    //For Home Page
    private var namePrefix: String
    private var firstName: String
    private var lastName: String
    private var maritalStatus: String?
    private var address: Address?
    private var home: Home?
    private var architectReference: String
    private var builderReference: String
    private var realtorReference: String
    private var homeImageFileName: String
    
    //For Plumbing Page
    private var hotWater: [HotWater]?
    private var boiler: [Boiler]?
    private var plumberReference: String
    private var plumbingServices: [ContractorService]?
    
    //For HVAC Page
    private var airHandler: [AirHandler]?
    private var compressor: [Compressor]?
    private var hvactechnicianReference: String
    private var hvacServices: [ContractorService]?
    
    //For Electrical Page
    private var panels: [Panel]?
    private var electricianReference: String
    private var electricalServices: [ContractorService]?
    
    //For Painting Page
    private var interiorPaintSurfaces: [PaintSurface]?
    private var exteriorPaintSurfaces: [PaintSurface]?
    private var painterReference: String
    private var paintingServices: [ContractorService]?
    
    public convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init(dictionary, customerId: nil)
    }
    
    public init(_ dictionary: Dictionary<String, AnyObject>, customerId id:String?) {
        self.customerId = id
        
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
            self.hotWater = [HotWater(hotWaterDictionary)]
        } else if let hotWatersDictionary = dictionary["hotWater"] as? NSArray {
            self.hotWater = [HotWater]()
            for hotWater in hotWatersDictionary {
                if let hotWaterDictionary = hotWater as? Dictionary<String, AnyObject> {
                    self.hotWater!.append(HotWater(hotWaterDictionary))
                }
            }
            self.hotWater!.sort()
        }
        if let boilerDictionary = dictionary["boiler"] as? Dictionary<String, AnyObject> {
            self.boiler = [Boiler(boilerDictionary)]
        } else if let boilersDictionary = dictionary["boiler"] as? NSArray {
            self.boiler = [Boiler]()
            for boiler in boilersDictionary {
                if let boilerDictionary = boiler as? Dictionary<String, AnyObject> {
                    self.boiler!.append(Boiler(boilerDictionary))
                }
            }
            self.boiler!.sort()
        }
        self.plumberReference = dictionary["plumberReference"] != nil ? dictionary["plumberReference"] as! String: ""
        if let plumbingArray = dictionary["plumbingServices"] as? NSArray {
            plumbingServices = [ContractorService]()
            for service in plumbingArray {
                if let serviceDictionary = service as? Dictionary<String, AnyObject> {
                    plumbingServices!.append(ContractorService(serviceDictionary))
                }
            }
            plumbingServices!.sort()
        }
        
        if let airHandlerDictionary = dictionary["airHandler"] as? Dictionary<String, AnyObject> {
            self.airHandler = [AirHandler(airHandlerDictionary)]
        } else if let airHandlerDictionary = dictionary["airHandler"] as? NSArray {
            self.airHandler = [AirHandler]()
            for airHandler in airHandlerDictionary {
                if let airHandlerDictionary = airHandler as? Dictionary<String, AnyObject> {
                    self.airHandler!.append(AirHandler(airHandlerDictionary))
                }
            }
            self.airHandler!.sort()
        }
        if let compressorDictionary = dictionary["compressor"] as? Dictionary<String, AnyObject> {
            self.compressor = [Compressor(compressorDictionary)]
        } else if let compressorDictionary = dictionary["compressor"] as? NSArray {
            self.compressor = [Compressor]()
            for compressor in compressorDictionary {
                if let compressorDictionary = compressor as? Dictionary<String, AnyObject> {
                    self.compressor!.append(Compressor(compressorDictionary))
                }
            }
            self.compressor!.sort()
        }
        self.hvactechnicianReference = dictionary["hvactechnicianReference"] != nil ? dictionary["hvactechnicianReference"] as! String: ""
        if let hvacArray = dictionary["hvacServices"] as? NSArray {
            hvacServices = [ContractorService]()
            for service in hvacArray {
                if let serviceDictionary = service as? Dictionary<String, AnyObject> {
                    hvacServices!.append(ContractorService(serviceDictionary))
                }
            }
            hvacServices!.sort()
        }
        
        if let panelsArray = dictionary["panels"] as? NSArray {
            panels = [Panel]()
            for panel in panelsArray {
                if let panelDictionary = panel as? Dictionary<String, AnyObject> {
                    panels!.append(Panel(panelDictionary))
                }
            }
            panels!.sort()
        }
        self.electricianReference = dictionary["electricianReference"] != nil ? dictionary["electricianReference"] as! String: ""
        if let electricalArray = dictionary["electricalServices"] as? NSArray {
            electricalServices = [ContractorService]()
            for service in electricalArray {
                if let serviceDictionary = service as? Dictionary<String, AnyObject> {
                    electricalServices!.append(ContractorService(serviceDictionary))
                }
            }
            electricalServices!.sort()
        }
        
        if let interiorPaintArray = dictionary["interiorPaintSurfaces"] as? NSArray {
            interiorPaintSurfaces = [PaintSurface]()
            for surface in interiorPaintArray {
                if let surfaceDictionary = surface as? Dictionary<String, AnyObject> {
                    interiorPaintSurfaces!.append(PaintSurface(surfaceDictionary))
                }
            }
            interiorPaintSurfaces!.sort()
        }
        if let exteriorPaintArray = dictionary["exteriorPaintSurfaces"] as? NSArray {
            exteriorPaintSurfaces = [PaintSurface]()
            for surface in exteriorPaintArray {
                if let surfaceDictionary = surface as? Dictionary<String, AnyObject> {
                    exteriorPaintSurfaces!.append(PaintSurface(surfaceDictionary))
                }
            }
            exteriorPaintSurfaces!.sort()
        }
        self.painterReference = dictionary["painterReference"] != nil ? dictionary["painterReference"] as! String: ""
        if let paintingArray = dictionary["paintingServices"] as? NSArray {
            paintingServices = [ContractorService]()
            for service in paintingArray {
                if let serviceDictionary = service as? Dictionary<String, AnyObject> {
                    paintingServices!.append(ContractorService(serviceDictionary))
                }
            }
            paintingServices!.sort()
        }
    }
    
    //MARK: Home Page
    func getNamePrefix() -> String {
        return namePrefix
    }
    func setNamePrefix(_ namePrefix: String) {
        self.namePrefix = namePrefix
    }
    func getFirstName() -> String {
        return firstName;
    }
    func setFirstName(_ firstName: String) {
        self.firstName = firstName
    }
    func getLastName() -> String {
        return lastName
    }
    func setLastName(_ lastName: String) {
        self.lastName = lastName
    }
    func getMaritalStatus() -> String? {
        return maritalStatus
    }
    func setMaritalStatus(_ maritalStatus: String?) -> Customer {
        self.maritalStatus = maritalStatus
        return self
    }
    func getName() -> String {
        return StringUtilities.getFormattedName(withPrefix: namePrefix, withFirstName: firstName, withLastName: lastName, withMaritalStatus: maritalStatus)
    }
    func getHome() -> Home? {
        return home;
    }
    func setHome(_ home: Home?) -> Customer {
        self.home = home;
        return self
    }
    func getAddress() -> Address? {
        return address;
    }
    func setAddress(_ address: Address?) -> Customer{
        self.address = address;
        return self
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
    
    // MARK: Plumbing Page
    func getHotWater() -> [HotWater]? {
        return hotWater
    }
    func setHotWater(to hotWater:HotWater, at index:Int) -> Customer {
        if self.hotWater != nil {
            if(index == -1) {
                self.hotWater!.append(hotWater)
            } else {
                self.hotWater![index] = hotWater
            }
        } else {
            self.hotWater = [HotWater]()
            self.hotWater!.append(hotWater)
        }
        return self
    }
    func deleteHotWater(at index:Int) -> Customer {
        guard self.hotWater != nil else {
            return self
        }
        self.hotWater!.remove(at: index)
        return self
    }
    func getBoiler() -> [Boiler]? {
        return boiler
    }
    func setBoiler(to boiler:Boiler, at index:Int) -> Customer {
        if self.boiler != nil {
            if(index == -1) {
                self.boiler!.append(boiler)
            } else {
                self.boiler![index] = boiler
            }
        } else {
            self.boiler = [Boiler]()
            self.boiler!.append(boiler)
        }
        return self
    }
    func deleteBoiler(at index:Int) -> Customer {
        guard self.boiler != nil else {
            return self
        }
        self.boiler!.remove(at: index)
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
    func setPlumber(to reference: String) -> Customer {
        self.plumberReference = reference
        return self
    }
    func updatePlumbingService(_ service:ContractorService, _ number:Int) -> Customer {
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
    
    
    // MARK:- HVAC Page
    func getAirHandler() -> [AirHandler]? {
        return airHandler
    }
    func setAirHandler(to airHandler:AirHandler, at index:Int) -> Customer {
        if self.airHandler != nil {
            if(index == -1) {
                self.airHandler!.append(airHandler)
            } else {
                self.airHandler![index] = airHandler
            }
        } else {
            self.airHandler = [AirHandler]()
            self.airHandler!.append(airHandler)
        }
        return self
    }
    func deleteAirHandler(at index:Int) -> Customer {
        guard self.airHandler != nil else {
            return self
        }
        self.airHandler!.remove(at: index)
        return self
    }
    func getCompressor() -> [Compressor]? {
        return compressor
    }
    func setCompressor(to compressor:Compressor, at index:Int) -> Customer {
        if self.compressor != nil {
            if(index == -1) {
                self.compressor!.append(compressor)
            } else {
                self.compressor![index] = compressor
            }
        } else {
            self.compressor = [Compressor]()
            self.compressor!.append(compressor)
        }
        return self
    }
    func deleteCompressor(at index:Int) -> Customer {
        guard self.compressor != nil else {
            return self
        }
        self.compressor!.remove(at: index)
        return self
    }
    func getHvacTechnician() -> String? {
        if(StringUtilities.isNilOrEmpty(hvactechnicianReference)) {
            return nil
        }
        return hvactechnicianReference
    }
    func setHvacTechnician(to reference: String) -> Customer {
        self.hvactechnicianReference = reference
        return self
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
    func getPanels() -> [Panel]? {
        return panels
    }
    func updatePanel(_ panel:Panel, _  number:Int) -> Customer {
        if let _ = panels {
            if(number == -1) {
                self.panels!.append(panel)
            } else {
                self.panels![number] = panel
            }
            return self
        } else {
            self.panels = [Panel]()
            self.panels!.append(panel)
            return self
        }
    }
    func deletePanel(_ index:Int) -> Customer {
        guard self.panels != nil else {
            return self
        }
        self.panels!.remove(at: index)
        return self
    }
    func getElectrician() -> String? {
        if(StringUtilities.isNilOrEmpty(electricianReference)) {
            return nil
        }
        return electricianReference
    }
    func setElectrician(to reference: String) -> Customer {
        self.electricianReference = reference
        return self
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
    func setPainter(to reference: String) -> Customer {
        self.painterReference = reference
        return self
    }
    func getPaintingServices() -> [ContractorService]? {
        return paintingServices
    }
    func updatePaintingService(_ service:ContractorService, _  number:Int) -> Customer {
        if let _ = paintingServices {
            if(number == -1) {
                self.paintingServices!.append(service)
            } else {
                self.paintingServices![number] = service
            }
            return self
        } else {
            self.paintingServices = [ContractorService]()
            self.paintingServices!.append(service)
            return self
        }
    }
    func removePaintingService(_ index:Int) -> Customer {
        guard self.paintingServices != nil else {
            return self
        }
        self.paintingServices!.remove(at: index)
        return self
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
    public func countServices(of type:String) -> Int? {
        if type == "Plumbing" {
            return plumbingServices?.count
        } else if type == "Hvac" {
            return hvacServices?.count
        } else if type == "Electrical" || type == "Electrician" {
            return electricalServices?.count
        } else if type == "Painting" || type == "Painter" {
            return paintingServices?.count
        }
        return nil
    }
    public func update(_ service:ContractorService, _  number:Int, of type:String) -> Customer {
        if type == "Plumbing" {
            return updatePlumbingService(service, number)
        } else if type == "Hvac" {
            return updateHvacService(service, number)
        } else if type == "Electrical" || type == "Electrician" {
            return updateElectricalService(service, number)
        } else if type == "Painting" || type == "Painter" {
            return updatePaintingService(service, number)
        }
        return self
    }
    public func deleteService(_ number:Int, of type:String) -> Customer {
        if type == "Plumbing" {
            return removePlumbingService(number)
        } else if type == "Hvac" {
            return removeHvacService(number)
        } else if type == "Electrical" || type == "Electrician" {
            return removeElectricalService(number)
        } else if type == "Painting" || type == "Painter" {
            return removePaintingService(number)
        }
        return self
    }
    
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
        
        if let hotWater = self.hotWater?.sorted() {
            var hotWaterArray = NSArray()
            for appliance in hotWater {
                hotWaterArray = hotWaterArray.adding(appliance.toDictionary()) as NSArray
            }
            dictionary["hotWater"] = hotWaterArray
        }
        if let boiler = self.boiler?.sorted() {
            var boilerArray = NSArray()
            for appliance in boiler {
                boilerArray = boilerArray.adding(appliance.toDictionary()) as NSArray
            }
            dictionary["boiler"] = boilerArray
        }
        dictionary["plumberReference"] = self.plumberReference as AnyObject
        if let plumbingServices = plumbingServices?.sorted() {
            var plumbingArray = NSArray()
            for service in plumbingServices {
                plumbingArray = plumbingArray.adding(service.toDictionary()) as NSArray
            }
            dictionary["plumbingServices"] = plumbingArray
        }
        
        if let airHandler = self.airHandler?.sorted() {
            var airHandlerArray = NSArray()
            for appliance in airHandler {
                airHandlerArray = airHandlerArray.adding(appliance.toDictionary()) as NSArray
            }
            dictionary["airHandler"] = airHandlerArray
        }
        if let compressor = self.compressor?.sorted() {
            var compressorArray = NSArray()
            for appliance in compressor {
                compressorArray = compressorArray.adding(appliance.toDictionary()) as NSArray
            }
            dictionary["compressor"] = compressorArray
        }
        dictionary["hvactechnicianReference"] = self.hvactechnicianReference as AnyObject
        if let hvacServices = hvacServices?.sorted() {
            var hvacArray = NSArray()
            for service in hvacServices {
                hvacArray = hvacArray.adding(service.toDictionary()) as NSArray
            }
            dictionary["hvacServices"] = hvacArray
        }
        
        if let panels = panels?.sorted() {
            var panelsArray = NSArray()
            for panel in panels {
                panelsArray = panelsArray.adding(panel.toDictionary()) as NSArray
            }
            dictionary["panels"] = panelsArray
        }
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
        if let paintingServices = paintingServices?.sorted() {
            var paintingArray = NSArray()
            for service in paintingServices {
                paintingArray = paintingArray.adding(service.toDictionary()) as NSArray
            }
            dictionary["paintingServices"] = paintingArray
        }
        dictionary["userType"] = self.userType as AnyObject
        
        return dictionary
    }
}
