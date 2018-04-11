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
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var installTextField: UITextField!
    @IBOutlet weak var lifeSpanTextField: UITextField!
    
    private var NotYetImplemented😤:AnyObject?
    /*
        Pass Two Appliances to Edit Screen
        Change to Table View Which has 2 appliances in it.
            -If you hit a text field it lets you edit in line?
            -If you click the install date it brings you to another screen
                -Date Picker on other page
     
        Save Button
    */
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(authentication.checkLogin(self)) {
            configureView()
        }
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        FirebaseAuthentication.sharedInstance.removeStateListener()
    }
    
    private func configureView() {
        if let navigationBar = navigationBar, let appliance = appliance {
            if let _ = appliance as? Boiler {
                navigationBar.title = "Edit Boiler"
            } else if let _ = appliance as? HotWater {
                navigationBar.title = "Edit Hot Water"
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
