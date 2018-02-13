//
//  BreakerTypePickerController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/12/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class BreakerTypePicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var selectedType = BreakerType.singlePole
    var viewController:UIViewController?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BreakerType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0) {
            self.selectedType = .singlePole
        } else if(row == 1) {
            //Alert selecting Double Pole will affect other breakers
            if let viewController = viewController as? EditBreakerViewController {
                viewController.present(viewController.alertController, animated: true, completion: nil)
            }
            else {
                print("ERROR")
            }
        }
        viewController!.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BreakerType(rawValue: row)?.description
    }
}


