//
//  CustomTableViewCells.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/3/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class NewPanelTableCell: UITableViewCell {
    @IBOutlet weak var isMainPanelSwitch: UISwitch!
    var isMainPanel = true
    @IBOutlet weak var panelAmperagepicker: PanelAmperagePicker!
    var panelAmperagePickerController = PanelAmperagePicker()
    var delegate: UIViewController?
    
    func setUp(viewController:UIViewController) {
        panelAmperagepicker.delegate = panelAmperagePickerController
        panelAmperagepicker.dataSource = panelAmperagePickerController
        panelAmperagePickerController.viewController = viewController
        delegate = viewController
    }
    
    @IBAction func isMainPanelValueChange(sender: UISwitch) {
        if let delegate = delegate as? NewPanelSetupViewController {
            delegate.newPanel!.isMainPanel = sender.on
        }
        panelAmperagePickerController.isMainPanel = sender.on
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
    
    func setUp(breakerInt:Int, description:String, type:BreakerType, pickerDelegate: UIPickerViewDelegate, breakers: [Breaker], viewDelegate: NewPanelSetupViewController) {
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
        if(type == .DoublePoleBottom) {
            breakerTypePicker.selectRow(1, inComponent: 0, animated: true)
            breakerTitleTextField.userInteractionEnabled = false
        } else {
            breakerTypePicker.selectRow(type.hashValue, inComponent: 0, animated: true)
            breakerTitleTextField.userInteractionEnabled = true
        }
        breakerTitleTextField.delegate = NewPanelTextFieldController()
        attachedBreakers = breakers
        breakerNumber = breakerInt
        delegate = viewDelegate
    }
    
    func getDescription() -> String {
        return breakerTitleTextField.text!
    }
    
    @IBAction func onTextChange(sender: UITextField) {
        let currentBreaker = attachedBreakers![breakerNumber]
        currentBreaker.breakerDescription = sender.text!
        if(currentBreaker.breakerType == .DoublePole)  {
            while(breakerNumber+2 >= attachedBreakers!.count) {
                attachedBreakers!.append(Breaker(number: breakerNumber+1, breakerDescription: ""))
            }
            attachedBreakers![breakerNumber+2].breakerDescription = sender.text!
        }
    }
}

class BreakerTableCell: UITableViewCell {
    @IBOutlet weak var leftNumber: UILabel!
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var rightNumber: UILabel!
    @IBOutlet weak var leftBreaker: UIView!
    @IBOutlet weak var rightBreaker: UIView!
    
    //Double Pole Connectors
    @IBOutlet var leftTopConnectors: [UIView]!
    @IBOutlet var leftBottomConnectors: [UIView]!
    @IBOutlet var rightTopConnectors: [UIView]!
    @IBOutlet var rightBottomConnectors: [UIView]!
    
  
    func setUp(leftNumber leftNumber: Int, leftTitle: String, leftBreakerType:BreakerType, rightNumber:Int, rightTitle:String, rightBreakerType:BreakerType) {
        leftBreaker.layer.cornerRadius = 5
        rightBreaker.layer.cornerRadius = 5
        leftBreaker.layer.masksToBounds = true
        rightBreaker.layer.masksToBounds = true
        
        //Set Up Left Breaker
        self.leftNumber.text = "\(leftNumber)"
        self.leftTitle.text = leftTitle
        
        if(leftBreakerType == .DoublePole) {
            for connector in leftBottomConnectors {
                connector.backgroundColor = UIColor.whiteColor()
            }
        } else {
            for connector in leftBottomConnectors {
                connector.backgroundColor = UIColor.clearColor()
            }
        }
        
        if(leftBreakerType == .DoublePoleBottom) {
            for connector in leftTopConnectors {
                connector.backgroundColor = UIColor.whiteColor()
            }
        } else {
            for connector in leftTopConnectors {
                connector.backgroundColor = UIColor.clearColor()
            }
        }
        
        
        //Set up Right Breaker
        if(rightNumber > 0) {
            self.rightNumber.text = "\(rightNumber)"
            rightBreaker.backgroundColor = UIColor.whiteColor()
        } else {
            rightBreaker.backgroundColor = UIColor.clearColor()
            self.rightNumber.text = ""
            hideAllConnectors()
        }
        self.rightTitle.text = rightTitle
        
        if(rightBreakerType == .DoublePole) {
            for connector in rightBottomConnectors {
                connector.backgroundColor = UIColor.whiteColor()
            }
        } else {
            for connector in rightBottomConnectors {
                connector.backgroundColor = UIColor.clearColor()
            }
        }
        
        if(rightBreakerType == .DoublePoleBottom) {
            for connector in rightTopConnectors {
                connector.backgroundColor = UIColor.whiteColor()
            }
        } else {
            for connector in rightTopConnectors {
                connector.backgroundColor = UIColor.clearColor()
            }
        }
    }

    private func hideAllConnectors() {
        for connector in rightTopConnectors {
            connector.backgroundColor = UIColor.clearColor()
        }
        for connector in rightBottomConnectors {
            connector.backgroundColor = UIColor.clearColor()
        }
    }
}




