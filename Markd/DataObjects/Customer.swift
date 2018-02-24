//
//  Customer.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import Firebase

public class Customer: CustomStringConvertible {
    public final let userType = "customer";
    
    //For Home Page
    private var namePrefix: String;
    private var firstName: String;
    private var lastName: String;
    private var maritalStatus: String;
    //TODO: private var address: Address;
    //TODO: private var home: Home;
    private var architectReference: String;
    private var builderReference: String;
    private var realtorReference: String;
    private var homeImageFileName: String;
    
    //For Plumbing Page
    //TODO: private var hotWater: HotWater;
    //TODO: private var boiler: Boiler;
    private var plumberReference: String;
    //TODO: private List<ContractorService> plumbingServices;
    
    //For HVAC Page
    //TODO: private var airHandler: AirHandler;
    //TODO: private var compressor: Compressor;
    private var hvactechnicianReference: String;
    //TODO: private List<ContractorService> hvacServices;
    
    //For Electrical Page
    //TODO: private List<Panel> panels;
    private var electricianReference: String;
    //TODO: private List<ContractorService> electricalServices;
    
    //For Painting Page
    //TODO: private List<PaintSurface> interiorPaintSurfaces;
    //TODO: private List<PaintSurface> exteriorPaintSurfaces;
    private var painterReference: String;
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.namePrefix = dictionary["namePrefix"] != nil ? dictionary["namePrefix"] as! String: ""
        self.firstName = dictionary["firstName"] != nil ? dictionary["firstName"] as! String: ""
        self.lastName = dictionary["lastName"] != nil ? dictionary["lastName"] as! String: ""
        self.maritalStatus = dictionary["maritalStatus"] != nil ? dictionary["maritalStatus"] as! String: ""
        //TODO: address
        //TODO: home
        self.architectReference = dictionary["architectReference"] != nil ? dictionary["architectReference"] as! String: ""
        self.builderReference = dictionary["builderReference"] != nil ? dictionary["builderReference"] as! String: ""
        self.realtorReference = dictionary["realtorReference"] != nil ? dictionary["realtorReference"] as! String: ""
        self.homeImageFileName = dictionary["homeImageFileName"] != nil ? dictionary["homeImageFileName"] as! String: ""
        
        //TODO: hotWater
        //TODO: boilder
        self.plumberReference = dictionary["plumberReference"] != nil ? dictionary["plumberReference"] as! String: ""
        //TODO: plumbingServices
        
        //TODO: AirHandler
        //TODO: Compressor
        self.hvactechnicianReference = dictionary["hvactechnicianReference"] != nil ? dictionary["hvactechnicianReference"] as! String: ""
        //TODO: hvacServices
        
        //TODO: panels
        self.electricianReference = dictionary["electricianReference"] != nil ? dictionary["electricianReference"] as! String: ""
        //TODO: electricalServices
        
        //TODO: interiorPaintSurfaces
        //TODO: exteriorPaintSurfaces
        self.painterReference = dictionary["painterReference"] != nil ? dictionary["painterReference"] as! String: ""
    }
    
    
    //TODO: getters/setters etc.
    func getName() -> String {
        return StringUtilities.getFormattedName(withPrefix: namePrefix, withFirstName: firstName, withLastName: lastName, withMaritalStatus: maritalStatus)
    }
}
