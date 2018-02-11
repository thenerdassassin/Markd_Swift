//
//  BreakerTypePickerController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/12/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class BreakerTypePicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var selectedType = BreakerType.SinglePole
    var viewController:UIViewController?
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BreakerType.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0) {
            self.selectedType = .SinglePole
        } else if(row == 1) {
            //Alert selecting Double Pole will affect other breakers
            if let viewController = viewController as? EditBreakerViewController {
                viewController.presentViewController(viewController.alertController, animated: true, completion: nil)
            }
            else {
                print("ERROR")
            }
        }
        viewController!.view.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BreakerType(rawValue: row)?.description
    }
}


