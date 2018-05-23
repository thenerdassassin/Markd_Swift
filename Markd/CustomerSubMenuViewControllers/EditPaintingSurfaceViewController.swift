//
//  EditPaintingSurfaceViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 5/23/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class EditPaintingSurfaceViewController: UITableViewController {
    var datePickerVisible = false
    var customerData:TempCustomerData?
    var paintSurfaceIndex: Int?
    var isInterior: Bool = false
    public var paintSurface:PaintSurface? {
        didSet {
            print(paintSurface!)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        /*
        if let customerData = customerData, let number = serviceIndex, let type = serviceType {
            if number < 0 {
                print("Add Service number: \(number) to \(type)")
                customerData.update(service!, number, of: type)
            } else {
                print("Number: \(number) changes to###\n\(service!)")
                customerData.update(service!, number, of: type)
            }
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
         */
    }
}
