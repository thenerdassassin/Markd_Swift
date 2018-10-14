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
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
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
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            if indexPath.section == 0 {
                customerData.removePaintSurface(at: indexPath.row, fromInterior: true)
            } else if indexPath.section == 1 {
                customerData.removePaintSurface(at: indexPath.row, fromInterior: false)
            } else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPaintingSurfaceSegue" {
            let sender = sender as! PaintSurfaceTableViewCell
            let destination = segue.destination as! EditPaintingSurfaceViewController
            guard let customerData = customerData, let paintSurface = sender.paintSurface else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            if sender.tag == 0 {
                destination.isInterior = true
            }
            destination.paintSurfaceIndex = sender.index
            destination.paintSurface = paintSurface
        }
    }
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
