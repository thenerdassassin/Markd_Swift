//
//  PanelViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/13/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class PanelViewController: UITableViewController {
    public var panelIndex:Int?
    public var panel:Panel? {
        didSet {
            configureView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        configureView()
    }
    private func configureView() {
        if let panel = panel {
            self.navigationItem.title = panel.panelDescription
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let panel = panel {
            if let breakers = panel.breakerList {
                return Int(ceil(Double(breakers.count)/2.0)) + 1
            }
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "panelHeaderCell", for: indexPath) as! PanelHeaderCell
            if let panel = panel {
                cell.panel = panel
            }
            return cell
        } else {
            let index = (indexPath.row-1)*2
            let cell = tableView.dequeueReusableCell(withIdentifier: "breakerCell", for: indexPath) as! BreakerTableCell
            let breakers = panel!.breakerList!
            if(index+1 >= breakers.count) {
                cell.setUp(leftNumber: breakers[index].number, leftTitle: breakers[index].breakerDescription, leftBreakerType: breakers[index].breakerType, rightNumber: -1, rightTitle: "", rightBreakerType: "Single-Pole")
            } else {
                cell.setUp(leftNumber: breakers[index].number, leftTitle: breakers[index].breakerDescription, leftBreakerType: breakers[index].breakerType, rightNumber: breakers[index+1].number, rightTitle: breakers[index+1].breakerDescription, rightBreakerType: breakers[index+1].breakerType)
            }
            return cell
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPanelSegue" {
            self.navigationItem.title = "Back"
            let destination = segue.destination as! EditPanelViewController
            destination.panel = panel
        }
    }
}

//Mark:- UITableViewCells
class PanelHeaderCell:UITableViewCell {
    @IBOutlet weak var panelLabel: UIView!
    @IBOutlet weak var panelTitle: UILabel!
    var panel: Panel? {
        didSet {
            setUpPanelLabel()
            panelTitle.text = panel!.getPanelTitle()
        }
    }
    
    private func setUpPanelLabel() {
        panelLabel.layer.cornerRadius = 5
        panelLabel.layer.masksToBounds = true
        panelLabel.layer.borderWidth = 1
        panelLabel.layer.borderColor = UIColor.black.cgColor
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
    
    func setUp(leftNumber: Int, leftTitle: String, leftBreakerType:String, rightNumber:Int, rightTitle:String, rightBreakerType:String) {
        leftBreaker.layer.cornerRadius = 5
        leftBreaker.layer.masksToBounds = true
        leftBreaker.layer.borderWidth = 1
        leftBreaker.layer.borderColor = UIColor.black.cgColor
        rightBreaker.layer.cornerRadius = 5
        rightBreaker.layer.masksToBounds = true
        rightBreaker.layer.borderWidth = 1
        rightBreaker.layer.borderColor = UIColor.black.cgColor
        
        //Set Up Left Breaker
        self.leftNumber.text = "\(leftNumber)"
        self.leftTitle.text = leftTitle
        
        if(leftBreakerType == "Double-Pole") {
            for connector in leftBottomConnectors {
                connector.backgroundColor = UIColor.white
            }
        } else {
            for connector in leftBottomConnectors {
                connector.backgroundColor = UIColor.clear
            }
        }
        
        if(leftBreakerType == "Double-Pole Bottom") {
            for connector in leftTopConnectors {
                connector.backgroundColor = UIColor.white
            }
        } else {
            for connector in leftTopConnectors {
                connector.backgroundColor = UIColor.clear
            }
        }
        
        
        //Set up Right Breaker
        if(rightNumber > 0) {
            self.rightNumber.text = "\(rightNumber)"
            rightBreaker.backgroundColor = UIColor.white
        } else {
            rightBreaker.layer.borderColor = UIColor.clear.cgColor
            rightBreaker.backgroundColor = UIColor.clear
            self.rightNumber.text = ""
            hideAllConnectors()
        }
        self.rightTitle.text = rightTitle
        
        if(rightBreakerType == "Double-Pole") {
            for connector in rightBottomConnectors {
                connector.backgroundColor = UIColor.white
            }
        } else {
            for connector in rightBottomConnectors {
                connector.backgroundColor = UIColor.clear
            }
        }
        
        if(rightBreakerType == "Double-Pole Bottom") {
            for connector in rightTopConnectors {
                connector.backgroundColor = UIColor.white
            }
        } else {
            for connector in rightTopConnectors {
                connector.backgroundColor = UIColor.clear
            }
        }
    }
    
    fileprivate func hideAllConnectors() {
        for connector in rightTopConnectors {
            connector.backgroundColor = UIColor.clear
        }
        for connector in rightBottomConnectors {
            connector.backgroundColor = UIColor.clear
        }
    }
}
