//
//  AddPanelViewController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/10/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class AddPanelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var panelLabelTextField: UITextField!
    var numberOfBreakers = 1
    
    // Mark:- Picker View Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfBreakers = pickerView.selectedRowInComponent(component)+1
    }

    // Mark:- Action Functions
    @IBAction func savePanel(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("NewPanelSetup", sender: nil)
    }
    @IBAction func cancelPanel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Mark:- Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "NewPanelSetup") {
            _ = segue.destinationViewController as! NewPanelSetupViewController
            //destination.numberOfBreakers = numberOfBreakers
            //destination.panelTitle = panelLabelTextField.text!
        }
    }
}
