//
//  NewPanelTextFieldController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 1/9/17.
//  Copyright © 2017 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class NewPanelTextFieldController: UITextField, UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}