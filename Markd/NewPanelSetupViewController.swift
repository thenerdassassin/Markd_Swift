//
//  NewPanelSetupViewController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/11/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

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
            newPanel = Panel(isMainPanel: true, amperage: MainPanelAmperage.OneHundred, breakers: breakers, manufacturer: .Unknown)
            panelSetupTable.reloadData()
        }
    }
    
    // Mark:- TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPanel!.breakers.count+1 //Extra one for NewPanelTableCell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewPanelCell") as! NewPanelTableCell
            cell.setUp(self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewPanelBreaker", forIndexPath: indexPath) as! NewPanelBreakerTableCell
            if let breakers = newPanel?.breakers {
                cell.setUp(indexPath.row-1, description: breakers[indexPath.row-1].breakerDescription, type: breakers[indexPath.row-1].breakerType, pickerDelegate: self, breakers: breakers, viewDelegate: self)
            }
            return cell
        }
    }    
    
    // Mark:- Button Events
    @IBAction func backClicked(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addBreaker(sender: UIBarButtonItem) {
        if let breakers = newPanel?.breakers {
            newPanel!.breakers.append(Breaker(number: breakers.count, breakerDescription: ""))
            panelSetupTable.reloadData()
        }
    }
    @IBAction func savePanel(sender: UIButton) {
        self.view.endEditing(true)
        self.performSegueWithIdentifier("SavePanel", sender: self)
    }
    
    // Mark: - Picker View Delegate
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = BreakerType(rawValue: row)?.description
        
        return pickerLabel!;
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let breakers = newPanel?.breakers {
            if row == 0 {
                let currentBreaker = breakers[pickerView.tag]
                if(currentBreaker.breakerType == .DoublePole) {
                    breakers[pickerView.tag+2].breakerType = .SinglePole
                } else if (currentBreaker.breakerType == .DoublePoleBottom) {
                    breakers[pickerView.tag-2].breakerType = .SinglePole
                }
                currentBreaker.breakerType = .SinglePole
                panelSetupTable.reloadData()
            }
            else if row == 1 {
                let currentBreaker = breakers[pickerView.tag]
                
                if(currentBreaker.breakerType == .DoublePoleBottom) {
                    breakers[pickerView.tag].breakerType = .DoublePoleBottom
                    breakers[pickerView.tag-2].breakerType = .DoublePole
                    panelSetupTable.reloadData()
                }
                else {
                    //Check if Breaker below is already Double Pole
                    if(pickerView.tag+2 < breakers.count) {
                        if(breakers[pickerView.tag + 2].breakerType == .DoublePole) {
                            panelSetupTable.reloadData()
                            return
                        }
                    }
                    
                    breakers[pickerView.tag].breakerType = .DoublePole
                    while(pickerView.tag+2 >= breakers.count) {
                        newPanel!.breakers.append(Breaker(number: breakers.count+1, breakerDescription: ""))
                    }
                    
                    breakers[pickerView.tag+2].breakerType = .DoublePoleBottom
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
