//
//  ZipCodeUtitilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 7/21/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public class ZipCodeUtilities {
    //Protocol
    private static let url = "https://www.zipcodeapi.com/rest/9xTgQJatx64XJImaOJdn8DMqCNEOSsm20fiQYskwyoui6QtVzGiIk58WSMLLf8Nf"
    
    private static func createUrl(for radius:Int, from zipcode:String) -> URL {
        if radius == 0 {
            return URL(string: "\(url)/radius.json/\(zipcode)/1/miles")!
        } else {
            return URL(string: "\(url)/radius.json/\(zipcode)/\(radius)/miles")!
        }
    }
    public static func getZipCodes(in range: Int, from zipcode: String, handler: @escaping ([String]) -> ()) {
        let url = ZipCodeUtilities.createUrl(for: range, from: zipcode)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    sortZipCodes(for: responseDictionary, with: handler)
                }  catch let error as NSError {
                    print(error.localizedDescription)
                    sortZipCodes(for: [:], with: handler)
                }
            } else if let error = error {
                print(error.localizedDescription)
                sortZipCodes(for: [:], with: handler)
            }
        }
        task.resume()
    }
    private static func sortZipCodes(for response: [String:Any], with handler: @escaping ([String]) -> ()) {
        var zipCodesDict:[String:Double] = [:]
        if let zipCodesArray = response["zip_codes"] as? NSArray {
            for zipCodeDict in zipCodesArray {
                if let zipCodeDict = zipCodeDict as? NSDictionary {
                    let zipCode = zipCodeDict["zip_code"] as! String
                    zipCodesDict[zipCode] = Double(truncating: zipCodeDict["distance"] as! NSNumber)
                } else {
                    print("sortZipCodes NSDict ERROR")
                    handler([])
                    return
                }
            }
        } else {
            print("getZipCodesHandler ERROR")
            handler([])
            return
        }
        handler((zipCodesDict.sorted(by: { $0.1 < $1.1 })).map{ $0.0 }) // create an array of the keys sorted by values
    }
}
