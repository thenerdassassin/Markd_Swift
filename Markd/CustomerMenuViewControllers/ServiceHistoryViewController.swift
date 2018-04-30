//
//  ServiceHistoryViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/28/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class ServiceHistoryViewController:UIViewController {
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "serviceMarkdHeaderSegue") {
            let destination = segue.destination as! MarkdHeaderViewController
            destination.configureHeader()
        }
    }
}
