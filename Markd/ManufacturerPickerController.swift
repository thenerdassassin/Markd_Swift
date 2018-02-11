//
//  ManufacturerPickerController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 1/5/17.
//  Copyright © 2017 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ManufacturerPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var viewController: UIViewController?
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PanelManufacturer.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PanelManufacturer(rawValue: row)?.description
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let viewController = viewController as? EditPanelViewController {
            viewController.panel?.manufacturer = PanelManufacturer(rawValue: row)!
        }
    }
}
