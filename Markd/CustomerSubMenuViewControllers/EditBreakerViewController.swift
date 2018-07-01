//
//  EditBreakerViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/30/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class EditBreakerViewController: UITableViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    var customerData:TempCustomerData?
    var breakerIndex:Int? {
        didSet {
            if breakerIndex == nil || breakerIndex! < 0 {
                self.title = "Add Breaker"
            } else {
                self.title = "Edit Breaker"
            }
        }
    }
    var breaker:Breaker? {
        didSet {
            print("Got Breaker to edit")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Breaker"
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        /*
        if let customerData = customerData, let number = panelIndex, let panel = panel {
            super.viewWillDisappear(animated)
            if number < 0 {
                print("Add Panel: \(panel)")
                customerData.updatePanel(at:number, to: panel.setNumberOfBreakers(numberOfBreakers!))
            } else {
                print("Number: \(number) changes to###\n\(panel)")
                customerData.updatePanel(at:number, to: panel.setNumberOfBreakers(numberOfBreakers!))
            }
        }
 */
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        if indexPath.row < 4 {
            hideEditCells()
        } else if indexPath.row == 4 {
            hideEditInstallDatePicker()
            toggleEditManufacturer()
        } else if isInstallDateRow(for: indexPath.row) {
            hideEditManufacturerPicker()
            toggleEditInstallDate()
        }
         */
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Mark: OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("EditBreakerViewController:- Got Customer Data")
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
