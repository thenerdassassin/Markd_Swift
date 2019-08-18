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
    var textFields = [UITextField](repeating: UITextField(), count: 3)
    var datePickerVisible = false
    var customerData:TempCustomerData?
    var paintSurfaceIndex: Int?
    var isInterior: Bool = false
    var delegate: PaintingViewController?
    public var paintSurface:PaintSurface? {
        didSet {
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
        if let customerData = customerData, let number = paintSurfaceIndex, let paintSurface = paintSurface {
            if number < 0 {
                print("Add PaintSurface: \(paintSurface)")
                delegate?.customerData = customerData.updatePaintSurface(at:number, fromInterior: isInterior, to: paintSurface)
            } else {
                print("Number: \(number) changes to###\n\(paintSurface)")
                delegate?.customerData = customerData.updatePaintSurface(at:number, fromInterior: isInterior, to: paintSurface)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            if datePickerVisible {
                return 5
            } else {
                return 4
            }
        }
        return 0
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if section == 0  {
            return "Paint Surface Details"
        }
        return ""
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "locationTableCell", for: indexPath) as! LocationTableViewCell
                if let paintSurface = paintSurface {
                    cell.surfaceViewController = self
                    cell.location = paintSurface.getLocation()
                }
                cell.tag = 0
                textFields[0] = cell.locationTextField
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "brandCell", for: indexPath) as! BrandTableViewCell
                if let paintSurface = paintSurface {
                    cell.surfaceViewController = self
                    cell.brand = paintSurface.getBrand()
                }
                cell.tag = 1
                textFields[1] = cell.brandTextView
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorTableViewCell
                if let paintSurface = paintSurface {
                    cell.surfaceViewController = self
                    cell.color = paintSurface.getColor()
                }
                cell.tag = 2
                textFields[2] = cell.colorTextView
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! PaintDateTableViewCell
                if let paintSurface = paintSurface {
                    cell.date = paintSurface.installDateAsString()
                }
                cell.tag = 3
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableCell", for: indexPath) as! PaintDatePickerTableViewCell
                if let paintSurface = paintSurface {
                    cell.surfaceViewController = self
                    cell.date = paintSurface.installDateAsString()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    //Mark:- DatePicker Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == 0 && indexPath.row == 3) {
            toggleDatePicker()
        } else {
            hideDatePicker()
        }
    }
    func toggleDatePicker() {
        self.view.endEditing(true)
        if(datePickerVisible) {
            hideDatePicker()
        } else {
            showDatePicker()
        }
    }
    func showDatePicker() {
        if(!datePickerVisible) {
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 4, section: 0)], with: UITableView.RowAnimation.fade)
            datePickerVisible = true
            tableView.endUpdates()
        }
    }
    func hideDatePicker() {
        if(datePickerVisible) {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: 4, section: 0)], with: UITableView.RowAnimation.fade)
            datePickerVisible = false
            tableView.endUpdates()
        }
    }
    
    func changeFirstResponder(fromIndex currentRow:Int) {
        if currentRow == 0 {
           textFields[1].becomeFirstResponder()
        } else if currentRow == 1 {
            textFields[2].becomeFirstResponder()
        } else if currentRow == 2 {
            toggleDatePicker()
        }
    }
}

//Mark:- TableViewCells
public class LocationTableViewCell: UITableViewCell, UITextFieldDelegate {
    var surfaceViewController:EditPaintingSurfaceViewController?
    public var location:String? {
        didSet {
            locationTextField.text = location
        }
    }
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
            locationTextField.delegate = self
        }
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        surfaceViewController!.hideDatePicker()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        surfaceViewController!.paintSurface!.setLocation(to: textField.text!)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        surfaceViewController!.changeFirstResponder(fromIndex: self.tag)
        return true;
    }
}
public class BrandTableViewCell: UITableViewCell, UITextFieldDelegate {
    var surfaceViewController:EditPaintingSurfaceViewController?
    public var brand:String? {
        didSet {
            brandTextView.text = brand
        }
    }
    @IBOutlet weak var brandTextView: UITextField! {
        didSet {
            brandTextView.delegate = self
        }
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        surfaceViewController!.hideDatePicker()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        surfaceViewController!.paintSurface!.setBrand(to: textField.text!)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        surfaceViewController!.changeFirstResponder(fromIndex: self.tag)
        return true;
    }
}
public class ColorTableViewCell: UITableViewCell, UITextFieldDelegate {
    var surfaceViewController:EditPaintingSurfaceViewController?
    public var color:String? {
        didSet {
            colorTextView.text = color
        }
    }
    @IBOutlet weak var colorTextView: UITextField! {
        didSet {
            colorTextView.delegate = self
        }
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        surfaceViewController!.hideDatePicker()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        surfaceViewController!.paintSurface!.setColor(to: textField.text!)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        surfaceViewController!.changeFirstResponder(fromIndex: self.tag)
        return true;
    }
}
class PaintDatePickerTableViewCell: UITableViewCell {
    var surfaceViewController:EditPaintingSurfaceViewController?
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.maximumDate = Date()
            set(to: date)
        }
    }
    public var date:String? {
        didSet {
            set(to: date)
        }
    }
    func set(to date: String?) {
        if let date = date {
            StringUtilities.set(datePicker, to: date)
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy"
        let date = dateFormatter.string(from:sender.date)
        let paintSurfaceToUpdate = surfaceViewController!.paintSurface!
        paintSurfaceToUpdate.updateInstallDate(to: date)
        surfaceViewController!.paintSurface = paintSurfaceToUpdate
        print("New Date:- \(date)")
    }
}
class PaintDateTableViewCell: UITableViewCell  {
    public var date:String? {
        didSet {
            dateLabel.text = date
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
}
