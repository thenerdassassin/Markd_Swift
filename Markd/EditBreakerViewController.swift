//
//  EditBreakerViewController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/3/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditBreakerViewController:UIViewController {
    
    @IBOutlet weak var amperagePicker: BreakerAmperagePicker!
    @IBOutlet weak var breakerTextField: UITextField!
    @IBOutlet weak var breakerTypePicker: UIPickerView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    //Mark:- AlertControllers
    let alertController = UIAlertController( title: "Are you sure?",
                                             message: "This action will affect other breakers.",
                                             preferredStyle: .alert)
    
    let notAllowedAlert = UIAlertController(title: "Not Allowed",
                                            message: "This breaker can not be a double pole.",
                                            preferredStyle: .alert)
    
    //Mark:- UIControllers
    var breakerTypePickerController = BreakerTypePicker()
    var amperagePickerController = BreakerAmperagePicker()
    var textFieldController = EditBreakerTextFieldController()
    
    var originalBreakerType:BreakerType?
    var nextBreakerIsDoublePole = false
    var delegate:BreakerEdit?
    var new = false
    var number = 0
    var breaker:Breaker? {
        didSet{
            configureView()
        }
    }
    
    override func viewDidLoad() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in self.breakerTypePicker.selectRow(0, inComponent: 0, animated: true)})
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {action in self.breakerTypePickerController.selectedType = .doublePole})
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        configureView()
    }
    
    func configureView() {
        //Editing Breaker
        if let breaker = breaker, let breakerTextBox = breakerTextField, let breakerTypePicker = breakerTypePicker, let amperagePicker = amperagePicker {
            //Initialize Text
            breakerTextBox.text = breaker.breakerDescription
            breakerTextBox.delegate = textFieldController
            navigationBar.title = "Breaker \(breaker.number)"
            
            //Setup Pickers
            breakerTypePickerController.viewController = self
            breakerTypePicker.delegate = breakerTypePickerController
            breakerTypePicker.dataSource = breakerTypePickerController
            
            amperagePickerController.viewController = self
            amperagePicker.delegate = amperagePickerController
            amperagePicker.dataSource = amperagePickerController
            
            //Enable or Disable Picker
            if(nextBreakerIsDoublePole) {
                breakerTypePicker.isUserInteractionEnabled = false
            } else {
                breakerTypePicker.isUserInteractionEnabled = true
            }
            
            //Store State
            originalBreakerType = breaker.breakerType
            breakerTypePickerController.selectedType = originalBreakerType!
            if(originalBreakerType == .doublePoleBottom) {
                breakerTypePicker.selectRow(1, inComponent: 0, animated: true)
            } else {
                breakerTypePicker.selectRow(breaker.breakerType.hashValue, inComponent: 0, animated: true)
            }
            amperagePicker.selectRow(breaker.amperage.hashValue, inComponent: 0, animated: true)
            
        }
        //Adding New Breaker
        else if let breakerTextField = breakerTextField, let breakerTypePicker = breakerTypePicker, let amperagePicker = amperagePicker {
            breakerTextField.delegate = textFieldController
            navigationBar.title = "Breaker \(number)"
            
            //Setup Pickers
            breakerTypePickerController.viewController = self
            breakerTypePicker.delegate = breakerTypePickerController
            breakerTypePicker.dataSource = breakerTypePickerController
            amperagePickerController.viewController = self
            amperagePicker.delegate = amperagePickerController
            amperagePicker.dataSource = amperagePickerController
            
            //Initialize Picker to 20A
            amperagePicker.selectRow(BreakerAmperage.twenty.hashValue, inComponent: 0, animated: true)
        }
    }
    
    // Mark:- Button Actions
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        let amperage = BreakerAmperage(rawValue: amperagePicker.selectedRow(inComponent: 0))!
        
        if(new) {
            delegate?.addBreaker(breakerDescription: breakerTextField.text!, amperage: amperage, breakerType: breakerTypePickerController.selectedType)
        } else {
            let breakerType = breakerTypePickerController.selectedType
            //Case in which breaker type stayed as .DoublePoleBottom
            if (breakerType == .doublePole && originalBreakerType == .doublePoleBottom) {
                delegate?.editBreaker(breakerDescription: breakerTextField.text!, amperage:amperage, breakerType: .doublePoleBottom)
                self.dismiss(animated: true, completion: nil)
                return
            }
            delegate?.editBreaker(breakerDescription: breakerTextField.text!, amperage: amperage, breakerType: breakerType)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //From: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    //Dismisses keyboard when clicking outside of textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
