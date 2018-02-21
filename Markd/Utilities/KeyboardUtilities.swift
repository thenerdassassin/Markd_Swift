//
//  KeyboardUtilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/20/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

struct KeyboardUtilities {
    public static func addKeyboardDismissal(_ target:UIView) {
        let tapper = UITapGestureRecognizer(target: target, action:#selector(target.endEditing))
        tapper.cancelsTouchesInView = false
        target.addGestureRecognizer(tapper)
    }
}
