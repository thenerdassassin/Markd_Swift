//
//  ElectricalPanelsViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/5/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ElectricalPanelsViewController: UITableViewController {
    public var customerData:TempCustomerData? {
        didSet {
            if let customerData = customerData {
                //panels = customerData.getPanels()
            }
        }
    }
    private var panels:[AnyObject]? {
        didSet {
            if let tableView = self.tableView {
                tableView.reloadSections([0], with: .fade)
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if panels != nil && panels!.count > 0 {
            return panels!.count
        }
        return 0
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        return "Electrical Panels"
    }

    /*
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
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if panels != nil && panels!.count > 0 {
            return true
        }
        return false
    }

    /*
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
    */

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
         if segue.identifier == "showPaintingSurfaceSegue" {
         let sender = sender as! PaintSurfaceTableViewCell
         let destination = segue.destination as! EditPaintingSurfaceViewController
         guard let customerData = customerData, let paintSurface = sender.paintSurface else {
         AlertControllerUtilities.somethingWentWrong(with: self)
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
    */
}

class ElectricalPanelTableViewCell:UITableViewCell {
    var index:Int?
    var panel:AnyObject? {
        didSet {
            if let panel = panel {
                //StringUtilities.set(textOf: locationLabel, to: paintSurface.getLocation())
                //brandLabel.text = paintSurface.getBrand()
                //colorLabel.text = paintSurface.getColor()
                //dateLabel.text = paintSurface.installDateAsString()
            }
        }
    }
    //@IBOutlet weak var locationLabel: UILabel!
    
}
