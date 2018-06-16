//
//  EditPanelViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/16/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditPanelViewController: UITableViewController {
    var editCellVisible = false
    var panel:Panel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editCellVisible {
            return 2
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "panelDescriptionTableCell", for: indexPath) as! PanelDescriptionTableViewCell
            cell.editPanelViewController = self
            cell.panelDescription = panel?.panelDescription
            return cell
        }
        return UITableViewCell()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Mark:- Helpers
    func hideEditCells() {
        editCellVisible = false
    }
}

//Mark:- TableViewCells
class PanelDescriptionTableViewCell: UITableViewCell, UITextFieldDelegate {
    var editPanelViewController:EditPanelViewController?
    @IBOutlet weak var panelDescriptionTextField: UITextField! {
        didSet {
            panelDescriptionTextField.delegate = self
        }
    }
    var panelDescription:String? {
        didSet {
            panelDescriptionTextField.text = panelDescription
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editPanelViewController!.hideEditCells()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //editPanelViewController!.paintSurface!.setLocation(to: textField.text!)
    }
}

class NumberOfBreakersTableViewCell: UITableViewCell {
    
    var panelDescription:String? {
        didSet {
            //panelDescriptionTextField.text = panelDescription
        }
    }
}


