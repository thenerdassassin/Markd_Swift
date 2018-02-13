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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BreakerAmperage.count.hashValue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BreakerAmperage(rawValue: row)?.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewController?.view.endEditing(true)
    }
}
