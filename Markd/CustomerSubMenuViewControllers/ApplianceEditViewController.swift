//
//  ApplianceEditViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/8/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class ApplianceEditViewController: UIViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    
    var delegate: PlumbingViewController?
    var appliance: Appliance?
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            configureView()
        }
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        FirebaseAuthentication.sharedInstance.removeStateListener()
    }
    
    private func configureView() {
        if let navigatoinBar = navigationBar, let appliance = appliance {
            if let _ = appliance as? Boiler {
                print("It is a Boiler!")
                navigatoinBar.title = "Edit Boiler"
            } else if let _ = appliance as? HotWater {
                print("It is a Domestic Hot Water!")
                navigatoinBar.title = "Edit Hot Water"
            }
        }
    }
}
