//
//  LifeSpanPickerView.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/14/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

protocol LifeSpanViewProtocol {
    func updateTextField(to value:String)
}
class LifeSpanPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    let pickerDictionary = [
        ("years", Array(1...50)),
        ("months", Array(1...12)),
        ("days", Array(1...365))
    ]
    
    var values:[Int]? = nil
    var lifeSpanViewController:LifeSpanViewProtocol?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return (values == nil ? pickerDictionary[0].1.count : values!.count)
        } else {
            return pickerDictionary.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0) {
            return "\(row+1)"
        } else {
            return pickerDictionary[row].0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 1) {
            values = pickerDictionary[row].1
            self.reloadAllComponents()
        }
        if let viewController = lifeSpanViewController {
            viewController.updateTextField(to: "\(self.selectedRow(inComponent: 0) + 1) \(pickerDictionary[self.selectedRow(inComponent: 1)].0)")
        }
    }
}
