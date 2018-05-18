//
//  PaintingSurfacesViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 5/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class PaintingSurfacesViewController:UITableViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData? {
        didSet {
            configureView()
        }
    }
    private var interiorPaintSurfaces:[AnyObject]?
    private var exteriorPaintSurfaces:[AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //Removes seperators after list
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    private func configureView() {
        if let _ = self.tableView, let customerData = customerData {
            //Set PaintSurfaces
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    override public func numberOfSections(in tableView: UITableView) -> Int {
        // Exterior, Interior Surfaces
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let surfaces = interiorPaintSurfaces {
                return surfaces.count
            }
        } else if section == 1 {
            if let surfaces = exteriorPaintSurfaces {
                return surfaces.count
            }
        }
        return 1
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Interior Surfaces"
        } else if section == 1 {
            return "Exterior Surfaces"
        } else {
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "testCell")!
        /*
        let serviceCell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! ServiceTableViewCell
        var service:ContractorService?
        serviceCell.tag = indexPath.section
        serviceCell.serviceIndex = indexPath.row
        
        if indexPath.section == 0 {
            service = interiorSurfaces?[indexPath.row]
        } else if indexPath.section == 1 {
            service = exteriorSurfaces?[indexPath.row]
        } } else {
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
        
        if let service = service {
            serviceCell.service = service
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "serviceDefaultCell", for: indexPath) as! ServiceTableViewCell
        }
        
        return serviceCell
         */
    }
}
