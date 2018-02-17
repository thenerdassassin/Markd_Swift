//
//  LoginViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/17/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        /*
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in self.breakerTypePicker.selectRow(0, inComponent: 0, animated: true)})
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {action in self.breakerTypePickerController.selectedType = .doublePole})
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        configureView()
         */
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "Login") {
            //Attempt firebase login
        }
        return true;
    }
    func configureView() {
        if let loginButton = loginButton {
            //TODO?
        }
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        //Check that username and password is present
    }
}
