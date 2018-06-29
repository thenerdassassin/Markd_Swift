//
//  CustomTableViewCells.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/3/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
/*
class NewPanelTableCell: UITableViewCell {
    @IBOutlet weak var isMainPanelSwitch: UISwitch!
    var isMainPanel = true
    @IBOutlet weak var panelAmperagepicker: PanelAmperagePicker!
    var panelAmperagePickerController = PanelAmperagePicker()
    var delegate: UIViewController?
    
    func setUp(_ viewController:UIViewController) {
        panelAmperagepicker.delegate = panelAmperagePickerController
        panelAmperagepicker.dataSource = panelAmperagePickerController
        panelAmperagePickerController.viewController = viewController
        delegate = viewController
    }
    
    @IBAction func isMainPanelValueChange(_ sender: UISwitch) {
        if let delegate = delegate as? NewPanelSetupViewController {
            delegate.newPanel!.isMainPanel = sender.isOn
        }
        panelAmperagePickerController.isMainPanel = sender.isOn
    }
    
}

class NewPanelBreakerTableCell: UITableViewCell {
    @IBOutlet weak var breakerLabel: UILabel!
    @IBOutlet weak var breakerTitleTextField: UITextField!
    @IBOutlet weak var breakerTypePicker: UIPickerView!
    let breakerTypeController = BreakerTypePicker()
    var attachedBreakers:[Breaker]?
    var breakerNumber = 0
    var delegate:NewPanelSetupViewController?
    
    func setUp(_ breakerInt:Int, description:String, type:BreakerType, pickerDelegate: UIPickerViewDelegate, breakers: [Breaker], viewDelegate: NewPanelSetupViewController) {
        breakerLabel.text = "\(breakerInt+1)"
        breakerTitleTextField.attributedPlaceholder = NSAttributedString(string: "Breaker")
        
        breakerTypePicker.dataSource = breakerTypeController
        breakerTypePicker.delegate = pickerDelegate
        breakerTypePicker.tag = breakerInt
        if(!description.isEmpty) {
            breakerTitleTextField.text = description
        } else {
            breakerTitleTextField.text = nil
        }
        if(type == .doublePoleBottom) {
            breakerTypePicker.selectRow(1, inComponent: 0, animated: true)
            breakerTitleTextField.isUserInteractionEnabled = false
        } else {
            breakerTypePicker.selectRow(type.hashValue, inComponent: 0, animated: true)
            breakerTitleTextField.isUserInteractionEnabled = true
        }
        breakerTitleTextField.delegate = NewPanelTextFieldController()
        attachedBreakers = breakers
        breakerNumber = breakerInt
        delegate = viewDelegate
    }
    
    func getDescription() -> String {
        return breakerTitleTextField.text!
    }
    
    @IBAction func onTextChange(_ sender: UITextField) {
        let currentBreaker = attachedBreakers![breakerNumber]
        currentBreaker.breakerDescription = sender.text!
        if(currentBreaker.breakerType == .doublePole)  {
            while(breakerNumber+2 >= attachedBreakers!.count) {
                attachedBreakers!.append(Breaker(number: breakerNumber+1, breakerDescription: ""))
            }
            attachedBreakers![breakerNumber+2].breakerDescription = sender.text!
        }
    }
}
}
*/



