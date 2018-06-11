//
//  PanelAmperagePickerController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 1/5/17.
//  Copyright © 2017 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
/*
class PanelAmperagePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var isMainPanel = true {
        didSet {
            var picker:UIPickerView?
            if let viewController = self.viewController as? EditPanelViewController {
                picker = viewController.panelAmperagePicker
            }
            else if let viewController = self.viewController as? NewPanelSetupViewController {
                let cell = viewController.panelSetupTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! NewPanelTableCell
                picker = cell.panelAmperagepicker
            }
            if let picker = picker {
                picker.reloadAllComponents()
                setAmperage(picker, picker.selectedRow(inComponent: 0))
            }
        }
    }
    var viewController: UIViewController?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(isMainPanel) {
            return MainPanelAmperage.count.hashValue
        } else {
            return SubPanelAmperage.count.hashValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(isMainPanel) {
            return MainPanelAmperage(rawValue: row)?.description
        } else {
            return SubPanelAmperage(rawValue: row)?.description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.setAmperage(pickerView, row)
    }
    
    func setAmperage(_ pickerView: UIPickerView, _ row: Int) {
        if let viewController = self.viewController as? EditPanelViewController {
            if(isMainPanel) {
                viewController.panel!.amperage = MainPanelAmperage(rawValue: row)!
            } else {
                viewController.panel!.amperage = SubPanelAmperage(rawValue: row)!
            }
        }
            
        else if let viewController = self.viewController as? NewPanelSetupViewController {
            if(isMainPanel) {
                viewController.newPanel!.amperage = MainPanelAmperage(rawValue: row)!
            } else {
                viewController.newPanel!.amperage = SubPanelAmperage(rawValue: row)!
            }
        }
    }
}
*/
