//
//  BreakerAmperagePickerController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 1/3/17.
//  Copyright © 2017 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class BreakerAmperagePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var viewController:UIViewController?
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BreakerAmperage.count.hashValue
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BreakerAmperage(rawValue: row)?.description
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewController?.view.endEditing(true)
    }
}