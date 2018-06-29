//
//  ManufacturerPickerView.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/27/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

protocol ManufacturerViewProtocol {
    var manufacturer:String? {get set}
}
public class ManufacturerPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var manufacturerViewController: ManufacturerViewProtocol?
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PanelManufacturer.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PanelManufacturer(rawValue: row)?.description
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        manufacturerViewController!.manufacturer = PanelManufacturer(rawValue: row)!.description
    }
}

enum PanelManufacturer: Int, CustomStringConvertible {
    case bryant = 0
    case generalElectric = 1
    case murry = 2
    case squareDHomline = 3
    case squareDQOSeries = 4
    case siemensITE = 5
    case wadsworth = 6
    case westinghouse = 7
    case other = 8
    
    static var count: Int { return PanelManufacturer.other.hashValue + 1 }
    
    var description: String {
        switch self {
        case .bryant: return "Bryant"
        case .generalElectric: return "General Electric"
        case .murry: return "Murry"
        case .squareDHomline: return "Square D Homline"
        case .squareDQOSeries: return "Square D QO"
        case .siemensITE: return "Siemens ITE"
        case .wadsworth: return "Wadsworth"
        case .westinghouse: return "Westinghouse"
        case .other: return "Other"
        }
    }
}
