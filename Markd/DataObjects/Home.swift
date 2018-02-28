//
//  Home.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/27/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class Home {
    private var bedrooms: Double
    private var squareFootage: Int
    private var bathrooms: Double
    
    public init(_ dictionary: Dictionary<String, AnyObject>) {
        self.bedrooms = dictionary["bedrooms"] != nil ? dictionary["bedrooms"] as! Double: 0.0
        self.squareFootage = dictionary["squareFootage"] != nil ? dictionary["squareFootage"] as! Int: 0
        self.bathrooms = dictionary["bathrooms"] != nil ? dictionary["bathrooms"] as! Double: 0.0
    }
    
    func getBedrooms() -> Double {
        return self.bedrooms
    }
    
    func setBedrooms(_ bedrooms:Double) {
        self.bedrooms = bedrooms
    }
    
    func getSquareFootage() -> Int {
        return self.squareFootage
    }
    
    func setSquareFootage(_ squareFootage:Int) {
        self.squareFootage = squareFootage
    }
    
    func getBathrooms() -> Double {
        return self.bathrooms
    }
    
    func setBathrooms(_ bathrooms:Double) {
        self.bathrooms = bathrooms
    }
}
