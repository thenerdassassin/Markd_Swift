//
//  ViewController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/3/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//
/*
import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BreakerEdit, PanelEdit {
    var electrician:Electrician = Electrician(url: "connwestelectric.com", company: "Conn West Electric, LLC", street: "135 N Maple Tree Hill Rd", city: "Oxford", state: "CT", zip: "06807", logo: UIImage(named: "connwestLogo")!, phoneNumber: "2038819055")
    
    var panels:[Panel] = [
        Panel(amperage: MainPanelAmperage.fourHundred, breakers:[Breaker(number:1, breakerDescription: "Master bedroom recepticals", breakerType: .singlePole), Breaker(number:2, breakerDescription: "Master bedroom lighting", breakerType: .singlePole),Breaker(number:3, breakerDescription: "Master bathroom GFCI", breakerType: .singlePole), Breaker(number:4, breakerDescription: "Master bathroom floor heat", breakerType: .singlePole), Breaker(number:5, breakerDescription: "Bedroom recepticals", breakerType: .singlePole), Breaker(number:6, breakerDescription: "2nd floor hallway lighting", breakerType: .singlePole), Breaker(number:7, breakerDescription: "Washing machine", breakerType: .singlePole), Breaker(number:8, breakerDescription: "Dryer", breakerType: .singlePole), Breaker(number: 9, breakerDescription: "Hot water heater", breakerType: .singlePole), Breaker(number:10, breakerDescription: "well pump", breakerType: .singlePole), Breaker(number: 11, breakerDescription: "Refrigerator", breakerType: .singlePole), Breaker(number: 12, breakerDescription: "Microwave", breakerType: .singlePole), Breaker(number: 13, breakerDescription: "Oven", breakerType: .singlePole), Breaker(number: 14, breakerDescription: "Kitchen Recepticals", breakerType: .singlePole), Breaker(number: 15, breakerDescription: "Kitchen island recepticals", breakerType: .singlePole), Breaker(number: 16, breakerDescription: "Kitchen Lighting", breakerType: .singlePole), Breaker(number: 17, breakerDescription: "Spot lights", breakerType: .singlePole), Breaker(number: 18, breakerDescription: "Garbage Disposal", breakerType: .singlePole), Breaker(number: 19, breakerDescription: "Dishwasher"), Breaker(number: 20, breakerDescription: "Kitchen Hood"), Breaker(number: 21, breakerDescription: "Dining room recepticals"), Breaker(number: 22, breakerDescription: "Dining room lighting"), Breaker(number: 23, breakerDescription: "Living room recpeticals"), Breaker(number: 24, breakerDescription: "Living Room lighting"), Breaker(number: 25, breakerDescription: "Family room recipticals"), Breaker(number: 26, breakerDescription: "Family room lighting"), Breaker(number: 27, breakerDescription: "Foyer recepticals"), Breaker(number: 28, breakerDescription: "Foyer lighting"), Breaker(number: 29, breakerDescription: "Furnace"), Breaker(number: 30, breakerDescription: "Air compressor"), Breaker(number: 31, breakerDescription: "Air handler"), Breaker(number: 32, breakerDescription: "Central vacuum"), Breaker(number: 33, breakerDescription: "Sump pump"), Breaker(number: 34, breakerDescription: "Basement Lighting"), Breaker(number: 35, breakerDescription: "Exterior Lighting"), Breaker(number: 36, breakerDescription: "Landscape Lighting"), Breaker(number: 37, breakerDescription: "Garage door receptical")]),
        Panel(isMainPanel: false, amperage: SubPanelAmperage.oneHundred, breakers:[Breaker(number: 1, breakerDescription: "Blah Blah recepticals"), Breaker(number: 2, breakerDescription: "Master bedroom lighting"),Breaker(number: 3, breakerDescription: "Master bathroom GFCI"), Breaker(number: 4, breakerDescription: "Master bathroom floor heat"), Breaker(number: 5, breakerDescription: "Bedroom recepticals"), Breaker(number: 6, breakerDescription: "2nd floor hallway lighting"), Breaker(number: 7, breakerDescription: "Washing machine"), Breaker(number: 8, breakerDescription: "Dryer"), Breaker(number: 9, breakerDescription: "Hot water heater"), Breaker(number: 10, breakerDescription: "well pump"), Breaker(number: 11, breakerDescription: "Refrigerator"), Breaker(number: 12, breakerDescription: "Microwave")])]
    
    var panelNumber = 0
    var breakerPressedIndex:Int?
    var breakerPressed:Breaker?
    var cellPressed:IndexPath?
    @IBOutlet weak var breakerTable: UITableView!
    @IBOutlet weak var panelLabel: UIView!
    @IBOutlet weak var panelTitle: UILabel!
    
    // Electrician Label
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var website: UIButton!
    
    let breakerActionSheet = UIAlertController(title: "Change Breaker", message: "Choose breaker action.", preferredStyle: .actionSheet)
    let addActionSheet = UIAlertController(title: "Create New", message: "What would you like to add?", preferredStyle: .actionSheet)
    var manufacturerLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Panel Title
        panelLabel.layer.cornerRadius = 5
        panelLabel.layer.masksToBounds = true
        panelTitle.text = panels[panelNumber].panelTitle
        
        // Set up Table Footer (Manfuctured by:)
        let tableViewFooter = UIView(frame: CGRect(x:0, y:0, width: breakerTable.frame.width, height: 20))
        tableViewFooter.backgroundColor = UIColor.darkGray
        manufacturerLabel = UILabel(frame: tableViewFooter.frame)
        manufacturerLabel?.textColor = UIColor.lightGray
        manufacturerLabel?.text = "    Manufactured by: \(panels[panelNumber].manufacturer)"
        tableViewFooter.addSubview(manufacturerLabel!)
        breakerTable.tableFooterView = tableViewFooter
        
        // Add Gesture Recognizers
        let longPressBreakerGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressBreaker))
        breakerTable.addGestureRecognizer(longPressBreakerGesture)
        
        let tapBreakerGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBreaker))
        breakerTable.addGestureRecognizer(tapBreakerGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        swipeGesture.direction = .left
        breakerTable.addGestureRecognizer(swipeGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe))
        swipeRightGesture.direction = .right
        breakerTable.addGestureRecognizer(swipeRightGesture)
        
        let tapTitle = UITapGestureRecognizer(target: self, action: #selector(self.tapPanelTitle))
        panelLabel.addGestureRecognizer(tapTitle)
        
        // Breaker Action Sheet set up
        let editAction = UIAlertAction(title: "Edit Breaker", style: .default, handler: {action in self.performSegue(withIdentifier: "EditBreaker", sender: nil)})
        let deleteAction = UIAlertAction(title: "Delete Breaker", style: .destructive,
                                         handler: {action in self.deleteBreaker() })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        breakerActionSheet.addAction(editAction)
        breakerActionSheet.addAction(deleteAction)
        breakerActionSheet.addAction(cancelAction)
        
        // Add Action Sheet set up
        let addPanelAction = UIAlertAction(title: "Add Panel", style: .default, handler: {action in self.performSegue(withIdentifier: "AddNewPanel", sender: nil)})
        let addBreakerAction = UIAlertAction(title: "Add Breaker", style: .default, handler: {action in self.performSegue(withIdentifier: "AddBreaker", sender: nil)})
        addActionSheet.addAction(addPanelAction)
        addActionSheet.addAction(addBreakerAction)
        addActionSheet.addAction(cancelAction)
        
        // Electrician Set up
        phoneNumber.setTitle(electrician.formattedPhone(), for: UIControlState())
        companyName.text = electrician.company
        website.setTitle(electrician.url, for: UIControlState())
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(ceil(Double(panels[panelNumber].breakers.count)/2.0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row*2
        let cell = tableView.dequeueReusableCell(withIdentifier: "breaker") as! BreakerTableCell
        let breakers = panels[panelNumber].breakers
        if(index+1 >= breakers.count) {
            cell.setUp(leftNumber: breakers[index].number, leftTitle: breakers[index].breakerDescription, leftBreakerType: breakers[index].breakerType, rightNumber: -1, rightTitle: "", rightBreakerType: .singlePole)
        } else {
            cell.setUp(leftNumber: breakers[index].number, leftTitle: breakers[index].breakerDescription, leftBreakerType: breakers[index].breakerType, rightNumber: breakers[index+1].number, rightTitle: breakers[index+1].breakerDescription, rightBreakerType: breakers[index+1].breakerType)
        }
        return cell
    }
    
    // Mark:- Gesture Function
    @objc func longPressBreaker(_ gesture:UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: breakerTable)
            cellPressed = breakerTable.indexPathForRow(at: point)
            let breakers = panels[panelNumber].breakers
            if(point.x < breakerTable.frame.width/2){
                breakerPressedIndex = cellPressed!.row*2
                breakerPressed = breakers[breakerPressedIndex!]
                
            } else {
                breakerPressedIndex = cellPressed!.row*2+1
                if(breakerPressedIndex! >= breakers.count) {
                    return
                }
                breakerPressed = breakers[breakerPressedIndex!]
            }
            self.present(breakerActionSheet, animated: true, completion: nil)
        }
    }
    
    @objc func tapBreaker(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: breakerTable)
        cellPressed = breakerTable.indexPathForRow(at: point)
        let breakers = panels[panelNumber].breakers
        if(point.x < breakerTable.frame.width/2){
            if let cellPressed = cellPressed {
                breakerPressedIndex = cellPressed.row*2
                breakerPressed = breakers[breakerPressedIndex!]
            } else { return /*footer pressed*/}
            
        } else {
            if let cellPressed = cellPressed {
                breakerPressedIndex = cellPressed.row*2+1
                breakerPressed = breakers[breakerPressedIndex!]
                if(breakerPressedIndex! >= breakers.count) {
                    return
                }
            } else { return /*footer pressed*/}
        }
        self.performSegue(withIdentifier: "ViewBreaker", sender: self)
    }
    
    @objc func tapPanelTitle(_ gesture:UILongPressGestureRecognizer) {
        self.performSegue(withIdentifier: "EditPanel", sender: self)
    }
    
    @objc func swipe(_ gesture:UISwipeGestureRecognizer) {
        if(gesture.direction == .left) {
            panelNumber = (panelNumber+1)%panels.count
            panelTitle.text = panels[panelNumber].panelTitle
            manufacturerLabel?.text = "    Manfactured by: \(panels[panelNumber].manufacturer)"
            breakerTable.reloadData()
        }
        if(gesture.direction == .right) {
            if(panelNumber == 0) {
                panelNumber = panels.count
            }
            panelNumber = (panelNumber-1)
            panelTitle.text = panels[panelNumber].panelTitle
            manufacturerLabel?.text = "    Manufactured by: \(panels[panelNumber].manufacturer)"
            breakerTable.reloadData()
        }
    }
    
    func deleteBreaker() {
        let lastBreaker = panels[panelNumber].breakers.last!
        if(breakerPressed!.breakerType == .doublePoleBottom) {
            let previousBreaker = panels[panelNumber].breakers[breakerPressedIndex!-2]
            previousBreaker.breakerType = .singlePole
        }
        else if(breakerPressed!.breakerType == .doublePole) {
            breakerPressed!.breakerType = .singlePole
            let nextBreaker = panels[panelNumber].breakers[breakerPressedIndex!+2]
            nextBreaker.breakerType = .singlePole
        }
        if(breakerPressed! == lastBreaker) {
            panels[panelNumber].breakers.removeLast()
        }
        else {
            //Reset to default values
            breakerPressed!.breakerDescription = ""
            breakerPressed!.breakerType = .singlePole
            breakerPressed!.amperage = .twenty
        }
        breakerTable.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.present(addActionSheet, animated: true, completion: nil)
    }
    
    // Mark:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //move segue to Detail View Controller
        if(segue.identifier == "EditBreaker") {
            let destination = segue.destination as! EditBreakerViewController
            destination.breaker = breakerPressed
            destination.delegate = self
            if breakerPressedIndex!+2 < panels[panelNumber].breakers.count {
                let nextBreaker = panels[panelNumber].breakers[breakerPressedIndex!+2]
                destination.nextBreakerIsDoublePole = ( nextBreaker.breakerType == BreakerType.doublePole)
            }
            return
        }
        
        if(segue.identifier == "AddNewPanel") {
            //nothing needed
        }
        
        if(segue.identifier == "AddBreaker") {
            let destination = segue.destination as! EditBreakerViewController
            destination.new = true
            destination.number = panels[panelNumber].breakers.count+1
            destination.delegate = self
            return
        }
        
        if(segue.identifier == "OpenWebsite") {
            let destination = segue.destination as! WebController
            destination.url = electrician.url
            return
        }
        
        if(segue.identifier == "ViewBreaker") {
            let destination = segue.destination as! DetailViewController
            destination.breaker = breakerPressed
            destination.delegate = self
            return
        }
        
        if(segue.identifier == "EditPanel") {
            let destination = segue.destination as! EditPanelViewController
            destination.panel = panels[panelNumber]
            destination.delegate = self
        }
    }
    
    // From: https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue){
        if let source = segue.source as? NewPanelSetupViewController {
            panels.append(source.newPanel!)
            panelNumber = panels.count-1
            panelTitle.text = source.newPanel!.panelTitle
            manufacturerLabel?.text = "    Manufactured by: \(source.newPanel!.manufacturer)"
            breakerTable.reloadData()
        }
        else if segue.source is WebController {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // Mark:- Protocol
    func editBreaker(breakerDescription: String, amperage:BreakerAmperage, breakerType:BreakerType) {
        
        //Update Selected Breaker
        breakerPressed?.breakerDescription = breakerDescription
        breakerPressed?.breakerType = breakerType
        breakerPressed?.amperage = amperage
        let currentPanel = panels[panelNumber]
        
        //Edited Top of Double Pole Breaker
        if(breakerType == .doublePole) {
            //Add Breakers if needed
            if(breakerPressedIndex!+2 >= currentPanel.breakers.count) {
                while(breakerPressedIndex!+2 > currentPanel.breakers.count) {
                  currentPanel.breakers.append(Breaker(number: currentPanel.breakers.count+1, breakerDescription: ""))
                }
                currentPanel.breakers.append(Breaker(number: currentPanel.breakers.count+1, breakerDescription: breakerDescription, amperage: amperage, breakerType: .doublePoleBottom))
            }
            //If no new breakers needed simply update the breaker below
            else {
                let bottomDoublePole = currentPanel.breakers[breakerPressedIndex!+2]
                bottomDoublePole.breakerType = .doublePoleBottom
                bottomDoublePole.breakerDescription = breakerDescription
                bottomDoublePole.amperage = amperage
            }
        }
            
        //Edited Bottom of Double Pole Breaker
        else if(breakerType == .doublePoleBottom) {
            //Must make corresponding changes to upper part of double pole
            let connectedBreaker = currentPanel.breakers[breakerPressedIndex!-2]
            connectedBreaker.breakerDescription = breakerDescription
            connectedBreaker.amperage = amperage
        }
            
        //Single Pole Breaker
        else {
            //Ensure above breaker is SinglePole
            if(breakerPressedIndex > 1){
                let aboveBreaker = currentPanel.breakers[breakerPressedIndex!-2]
                aboveBreaker.breakerType = .singlePole
            }
            //Ensure below breaker is SinglePole
            if(breakerPressedIndex! + 2 < currentPanel.breakers.count) {
                let belowBreaker = currentPanel.breakers[breakerPressedIndex!+2]
                belowBreaker.breakerType = .singlePole
            }
        }
        
        breakerTable.reloadData()
    }

    func addBreaker(breakerDescription: String, amperage: BreakerAmperage, breakerType: BreakerType) {
        let currentPanel = panels[panelNumber]
        currentPanel.breakers.append(Breaker(number: currentPanel.breakers.count+1, breakerDescription: breakerDescription, amperage: amperage, breakerType: breakerType))
        
        //If Double Pole is selected need to pad on two new breakers
        if(breakerType == .doublePole) {
            currentPanel.breakers.append(Breaker(number: currentPanel.breakers.count+1, breakerDescription: ""))
            currentPanel.breakers.append(Breaker(number: currentPanel.breakers.count+1, breakerDescription: breakerDescription, amperage: amperage, breakerType: .doublePoleBottom))
        }
        breakerTable.reloadData()
    }
    
    func editPanel(_ newPanel: Panel) {
        panelTitle.text = newPanel.panelTitle
        manufacturerLabel?.text = "    Manufactured by: \(panels[panelNumber].manufacturer)"
        panels[panelNumber] = newPanel
        breakerTable.reloadData()
    }
}
*/
