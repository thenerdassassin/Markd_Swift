//
//  ContractorMainViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 10/16/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class ContractorMainViewController: UIViewController {
    
    @IBAction func onLogOut(_ sender: UIButton) {
        FirebaseAuthentication.sharedInstance.signOut(self)
    }
}
