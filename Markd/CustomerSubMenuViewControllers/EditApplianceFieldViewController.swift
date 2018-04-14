//
//  ApplianceEditFieldViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/10/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class EditApplianceFieldViewController: UIViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    
    var applianceIndex: Int?
    var editType: String?
    var originalValue: String?
    var delegate: EditApplianceTableViewController?
    var fieldEditing: String?
  
    @IBOutlet weak var textField: UITextField!
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!authentication.checkLogin(self)) {
            print("Not logged in.")
        }
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
    }
    
    private func configureView() {
        if let text = originalValue, let editType = editType, let textField = textField {
            textField.text = text
            
            //Sets placeholder to Title without "Edit "
            if var placeholder = self.title {
                placeholder.removeFirst(5)
                textField.placeholder = placeholder
            }
            
            if(editType == "String") {
                textField.isEnabled = true
            } else {
                textField.isEnabled = false
            }
        }
    }
    @IBAction func saveButtonClick(_ sender: Any) {
        if let text = textField.text, let delegate = delegate, let index = applianceIndex, let field = fieldEditing {
            delegate.change(field, at: index, to: text)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
