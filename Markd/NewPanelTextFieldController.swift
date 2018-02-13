//
//  NewPanelTextFieldController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 1/9/17.
//  Copyright © 2017 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class NewPanelTextFieldController: UITextField, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
