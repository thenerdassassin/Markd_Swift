//
//  DetailsNavigationController.swift
//  Markd
//
//  Created by Joshua Schmidt on 11/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class DetailsNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
    }
}
