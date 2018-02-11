//
//  BreakerTypePickerView.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/11/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class BreakerTypePickerView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let breakerTypes = ["Single-Pole, Double-Pole"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breakerTypes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breakerTypes[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(breakerTypes[row])
    }
}