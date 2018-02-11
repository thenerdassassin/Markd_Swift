//
//  WebController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/18/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class WebController: UIViewController, UIWebViewDelegate {
    var url:String? {
        didSet {
            configureView()
        }
    }
    
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        configureView()
    }
    
    func configureView() {
        if let url = url, let webView = webView {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.\(url)")!))
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
