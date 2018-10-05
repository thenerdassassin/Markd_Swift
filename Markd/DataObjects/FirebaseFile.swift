//
//  FirebaseFile.swift
//  Markd
//
//  Created by Joshua Schmidt on 9/29/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class FirebaseFile:CustomStringConvertible {
    private var fileName:String
    private var guid:String
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.fileName = dictionary["fileName"] != nil ? dictionary["fileName"] as! String: ""
        self.guid = dictionary["guid"] != nil ? dictionary["guid"] as! String: ""
    }
    public func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["fileName"] = self.fileName as AnyObject
        dictionary["guid"] = self.guid as AnyObject
        return dictionary
    }
    
    public func getFileName() -> String {
        return fileName;
    }
    
    public func setFileName(to fileName:String) {
        self.fileName = fileName;
    }
    
    public func getGuid() -> String {
        return guid
    }
    public func setGuid(to guid:String?) -> String {
        if let guid = guid {
            self.guid = guid
        } else {
            self.guid = UUID.init().uuidString
        }
        return self.guid
    }
}
