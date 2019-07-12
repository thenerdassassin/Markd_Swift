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
    var delegate: PaintingViewController?
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
        
        if indexPath.section == 0 && interiorPaintSurfaces != nil && interiorPaintSurfaces!.count > indexPath.row {
                paintSurface = interiorPaintSurfaces?[indexPath.row]
        } else if indexPath.section == 1 && exteriorPaintSurfaces != nil && exteriorPaintSurfaces!.count > indexPath.row {
                paintSurface = exteriorPaintSurfaces?[indexPath.row]
        } else if indexPath.section > 1 {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
        
        if let paintSurface = paintSurface {
            paintSurfaceCell.paintSurface = paintSurface
            return paintSurfaceCell
        }
        return tableView.dequeueReusableCell(withIdentifier: "paintSurfaceDefaultCell", for: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 0 && interiorPaintSurfaces != nil && interiorPaintSurfaces!.count > 0) ||
            (indexPath.section == 1 && exteriorPaintSurfaces != nil && exteriorPaintSurfaces!.count > 0)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            if indexPath.section == 0 {
                delegate?.customerData = customerData.removePaintSurface(at: indexPath.row, fromInterior: true)
            } else if indexPath.section == 1 {
                delegate?.customerData = customerData.removePaintSurface(at: indexPath.row, fromInterior: false)
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
            destination.delegate = delegate
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
