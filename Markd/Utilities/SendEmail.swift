//
//  SendEmail.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/13/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public struct SendEmail {
    private static let TO:String = "schmidt.uconn@gmail.com"
    private static let DOMAIN:String = "sandbox11b0c4f4831d4edaa9d23ba61c6d125f.mailgun.org"
    private static let API_KEY:String = "key-98ae211f5d8dd12c4639ab41ef6ccf9a"
    enum MyError: Error {
        case GetUrlFailure(String)
    }
    
    private static func getUrl(_ message: String, _ from: String) -> URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.mailgun.net"
        urlComponents.path = "/v3/\(DOMAIN)/messages"
        let to = URLQueryItem(name: "to", value: TO)
        let text = URLQueryItem(name: "text", value: message)
        let from = URLQueryItem(name: "from", value: from)
        let subject = URLQueryItem(name: "subject", value: "Markd help")
        urlComponents.queryItems = [to, from, subject, text]
        return urlComponents.url
    }
    
    public static func send(_ message: String, from:String, successHandler: @escaping (Data?, URLResponse?) -> Void, errorHandler: @escaping (Error) -> Void) {
        let loginData = String(format: "%@:%@", "api", API_KEY).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let url = getUrl(message, from) {
            debugPrint(url)
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error  {
                    errorHandler(error)
                } else {
                    successHandler(data, response)
                }
            }
            task.resume()
        } else {
           errorHandler(MyError.GetUrlFailure("message:\(message), from:\(from)"))
        }
    }
}
