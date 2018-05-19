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
            if let customerData = customerData {
                interiorPaintSurfaces = customerData.getInteriorPaintSurfaces()
                exteriorPaintSurfaces = customerData.getExteriorPaintSurfaces()
            }
        }
    }
    private var interiorPaintSurfaces:[PaintSurface]? {
        didSet {
            if let tableView = self.tableView {
                tableView.reloadSections([0], with: .fade)
            }
        }
    }
    private var exteriorPaintSurfaces:[PaintSurface]? {
        didSet {
            if let tableView = self.tableView {
                tableView.reloadSections([1], with: .fade)
            }
        }
    }
    
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
        if let _ = customerData {
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
                if surfaces.count != 0 {
                    return surfaces.count
                }
            }
        } else if section == 1 {
            if let surfaces = exteriorPaintSurfaces {
                if surfaces.count != 0 {
                    return surfaces.count
                }
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
        let paintSurfaceCell = tableView.dequeueReusableCell(withIdentifier: "paintingSurfaceCell") as! PaintSurfaceTableViewCell
        paintSurfaceCell.tag = indexPath.section
        paintSurfaceCell.index = indexPath.row
        
        var paintSurface:PaintSurface?
        if indexPath.section == 0 {
            paintSurface = interiorPaintSurfaces?[indexPath.row]
        } else if indexPath.section == 1 {
            paintSurface = exteriorPaintSurfaces?[indexPath.row]
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
        if let paintSurface = paintSurface {
            paintSurfaceCell.paintSurface = paintSurface
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "paintSurfaceDefaultCell", for: indexPath)
        }
        return paintSurfaceCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func onAddSurfaceAction(_ sender: UIBarButtonItem) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Add Paint",
            andMessage: "What surface type is being added?",
            withOptions: [
                UIAlertAction(title: "Interior Surface", style: .default, handler: addSurfaceHandler),
                UIAlertAction(title: "Exterior Surface", style: .default, handler: addSurfaceHandler),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ],
            in: self
        )
    }
    func addSurfaceHandler(alert: UIAlertAction!) {
        if alert.title != nil && alert.title != "Cancel" {
            //TODO:
            //self.performSegue(withIdentifier: "addContractorServiceSegue", sender: alert)
        }
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            if indexPath.section == 0 {
                customerData.removePaintSurface(at: indexPath.row, fromInterior: true)
            } else if indexPath.section == 1 {
                customerData.removePaintSurface(at: indexPath.row, fromInterior: false)
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self)
            }
        }
    }
    //TODO:
    /* MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContractorServiceSegue" {
            let sender = sender as! ServiceTableViewCell
            let destination = segue.destination as! ContractorServiceTableViewController
            guard let customerData = customerData, let service = sender.service else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            destination.serviceType = getTypeFromTag(sender.tag)
            destination.serviceIndex = sender.serviceIndex
            destination.service = service
        } else if segue.identifier == "addContractorServiceSegue" {
            let sender = sender as! UIAlertAction
            let destination = segue.destination as! ContractorServiceTableViewController
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            destination.serviceType = sender.title
            destination.serviceIndex = -1
            let newService = ContractorService()
            newService.setGuid(nil)
            destination.service = newService
        }
    }
     */
}

class PaintSurfaceTableViewCell:UITableViewCell {
    var index:Int?
    var paintSurface:PaintSurface? {
        didSet {
            if let paintSurface = paintSurface {
                StringUtilities.set(textOf: locationLabel, to: paintSurface.getLocation())
                brandLabel.text = paintSurface.getBrand()
                colorLabel.text = paintSurface.getColor()
                dateLabel.text = paintSurface.installDateAsString()
            }
        }
    }
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
}
