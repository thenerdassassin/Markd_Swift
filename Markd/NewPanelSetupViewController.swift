//
//  NewPanelSetupViewController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/11/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
/*
class NewPanelSetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {
    //var breakers:[Breaker] = []
    var newPanel:Panel?
    
    @IBOutlet weak var panelSetupTable: UITableView!
    
    override func viewDidLoad() {
        configureView()
    }
    
    func configureView(){
        if let panelSetupTable = panelSetupTable {
            var breakers:[Breaker] = []
            breakers.append(Breaker(number: 1, breakerDescription: ""))
            breakers.append(Breaker(number: 2, breakerDescription: ""))
            newPanel = Panel(isMainPanel: true, amperage: MainPanelAmperage.oneHundred, breakers: breakers, manufacturer: .unknown)
            panelSetupTable.reloadData()
        }
    }
    
    // Mark:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPanel!.breakers.count+1 //Extra one for NewPanelTableCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewPanelCell") as! NewPanelTableCell
            cell.setUp(self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewPanelBreaker", for: indexPath) as! NewPanelBreakerTableCell
            if let breakers = newPanel?.breakers {
                cell.setUp(indexPath.row-1, description: breakers[indexPath.row-1].breakerDescription, type: breakers[indexPath.row-1].breakerType, pickerDelegate: self, breakers: breakers, viewDelegate: self)
            }
            return cell
        }
    }    
    
    // Mark:- Button Events
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBreaker(_ sender: UIBarButtonItem) {
        if let breakers = newPanel?.breakers {
            newPanel!.breakers.append(Breaker(number: breakers.count, breakerDescription: ""))
            panelSetupTable.reloadData()
        }
    }
    @IBAction func savePanel(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "SavePanel", sender: self)
    }
    
    // Mark: - Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = BreakerType(rawValue: row)?.description
        
        return pickerLabel!;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let breakers = newPanel?.breakers {
            if row == 0 {
                let currentBreaker = breakers[pickerView.tag]
                if(currentBreaker.breakerType == .doublePole) {
                    breakers[pickerView.tag+2].breakerType = .singlePole
                } else if (currentBreaker.breakerType == .doublePoleBottom) {
                    breakers[pickerView.tag-2].breakerType = .singlePole
                }
                currentBreaker.breakerType = .singlePole
                panelSetupTable.reloadData()
            }
            else if row == 1 {
                let currentBreaker = breakers[pickerView.tag]
                
                if(currentBreaker.breakerType == .doublePoleBottom) {
                    breakers[pickerView.tag].breakerType = .doublePoleBottom
                    breakers[pickerView.tag-2].breakerType = .doublePole
                    panelSetupTable.reloadData()
                }
                else {
                    //Check if Breaker below is already Double Pole
                    if(pickerView.tag+2 < breakers.count) {
                        if(breakers[pickerView.tag + 2].breakerType == .doublePole) {
                            panelSetupTable.reloadData()
                            return
                        }
                    }
                    
                    breakers[pickerView.tag].breakerType = .doublePole
                    while(pickerView.tag+2 >= breakers.count) {
                        newPanel!.breakers.append(Breaker(number: breakers.count+1, breakerDescription: ""))
                    }
                    
                    breakers[pickerView.tag+2].breakerType = .doublePoleBottom
                    breakers[pickerView.tag+2].breakerDescription = breakers[pickerView.tag].breakerDescription
                    panelSetupTable.reloadData()
                }
            }
        }
    }
    
    func reload() {
        panelSetupTable.reloadData()
    }
    
    //Dismisses keyboard when clicking outside of textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
*/
