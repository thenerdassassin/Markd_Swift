//
//  ContractorServiceTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/28/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ContractorServiceTableViewController: UITableViewController {
    var datePickerVisible = false
    var customerData:TempCustomerData?
    var serviceIndex: Int?
    var serviceType: String?
    public var service:ContractorService? {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        if let customerData = customerData, let number = serviceIndex, let type = serviceType {
            if number < 0 {
                print("Add Service number: \(number) to \(type)")
                customerData.update(service!, number, of: type)
                if let serviceCount = customerData.getServiceCount(of: type) {
                    serviceIndex =  serviceCount - 1
                }
            } else {
                print("Number: \(number) changes to###\n\(service!)")
                customerData.update(service!, number, of: type)
            }
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
    }
    
    @IBAction func onAddFileAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showServiceFileSegue", sender: self)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            if datePickerVisible {
                return 4
            } else {
                return 3
            }
        } else if(section == 1) {
            guard let files = service?.getFiles() else {
                return 1
            }
            return files.count > 0 ? files.count:1
        }
        return 0
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if section == 0  {
            return "Service Details"
        } else if section == 1 {
            return "Files"
        }
        return ""
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50.0
        } else {
            return 30.0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "contractorTableCell", for: indexPath) as! ServiceContractorTableViewCell
                if let service = service {
                    cell.serviceViewController = self
                    cell.contractor = service.getContractor()
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsTableViewCell
                if let service = service {
                    cell.serviceViewController = self
                    cell.comments = service.getComments()
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
                if let service = service {
                    cell.date = service.getDate()
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableCell", for: indexPath) as! DatePickerTableViewCell
                if let service = service {
                    cell.serviceViewController = self
                    cell.date = service.getDate()
                }
                return cell
            }
        } else if(indexPath.section == 1) {
            guard let files = service?.getFiles() else {
                return noFilesCell(indexPath)
            }
            if files.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "serviceFileTableCell", for: indexPath)
                cell.textLabel?.text = files[indexPath.row].getFileName()
                cell.tag = indexPath.row
                return cell
            }
            return noFilesCell(indexPath)
        }
        // Configure the cell...
        return UITableViewCell()
    }
    
    private func noFilesCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceFileTableCell", for: indexPath)
        cell.accessoryType = .none
        cell.textLabel?.text = "No files yet!"
        return cell
    }
    
    //Mark:- DatePicker Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == 0 && indexPath.row == 2) {
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
            tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: UITableViewRowAnimation.fade)
            datePickerVisible = true
            tableView.endUpdates()
        }
    }
    func hideDatePicker() {
        if(datePickerVisible) {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: 3, section: 0)], with: UITableViewRowAnimation.fade)
            datePickerVisible = false
            tableView.endUpdates()
        }
    }

    // Mark:- Files
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 1)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let customerData = customerData else {
                print("Customer Data not set")
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            guard let service = service, let index = serviceIndex, let type = serviceType else {
                print("Missing service information")
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            // Delete the row from the data source
            var files = service.getFiles()
            files.remove(at: indexPath.row)
            customerData.update(service.setFiles(files), index, of: type)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("shouldPerformSegue")
        if(identifier == "showServiceFileSegue") {
            if let sender = sender as? UITableViewCell {
                guard let files = service?.getFiles(), let _ = customerData?.getUid() else {
                    return false
                }
                if(sender.tag < 0 || sender.tag >= files.count) {
                    return false
                }
            }
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareSegue")
        // Pass the selected file to the new view controller.
        if(segue.identifier == "showServiceFileSegue") {
            let destination = segue.destination as! ServieFileViewController
            destination.serviceType = serviceType
            destination.serviceIndex = serviceIndex
            if let sender = sender as? UITableViewCell {
                destination.fileIndex = sender.tag
                destination.service = service
            } else {
                if let service = service {
                    var files = service.getFiles()
                    files.append(FirebaseFile([:]))
                    destination.fileIndex = files.count-1
                    destination.service = service.setFiles(files)
                } else {
                    AlertControllerUtilities.somethingWentWrong(with: self)
                }
            }
            customerData?.removeListeners()
        }
    }
}

//Mark:- TableViewCells
public class ServiceContractorTableViewCell: UITableViewCell, UITextFieldDelegate {
    var serviceViewController:ContractorServiceTableViewController?
    public var contractor:String? {
        didSet {
            contractorTextField.text = contractor
        }
    }
    @IBOutlet weak var contractorTextField: UITextField! {
        didSet {
            contractorTextField.delegate = self
        }
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        serviceViewController!.hideDatePicker()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        serviceViewController!.service!.setContractor(textField.text!)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contractorTextField.resignFirstResponder()
        return true;
    }
}
public class CommentsTableViewCell: UITableViewCell, UITextViewDelegate {
    var serviceViewController:ContractorServiceTableViewController?
    public var comments:String? {
        didSet {
            commentsTextView.text = comments
            if StringUtilities.isNilOrEmpty(commentsTextView.text) {
                commentsTextView.textColor = UIColor.lightGray
                commentsTextView.text = "Comments"
            }
        }
    }
    @IBOutlet weak var commentsTextView: UITextView! {
        didSet {
            commentsTextView.delegate = self
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comments" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        serviceViewController!.hideDatePicker()
        return true
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        serviceViewController!.service!.setComments(textView.text!)
        if StringUtilities.isNilOrEmpty(textView.text) {
            textView.textColor = UIColor.lightGray
            textView.text = "Comments"
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
class DatePickerTableViewCell: UITableViewCell {
    var serviceViewController:ContractorServiceTableViewController?
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
        let dateComponents = StringUtilities.getComponentsFrom(dotFormmattedString: date)
        guard dateComponents.count == 3 else {
            AlertControllerUtilities.somethingWentWrong(with: serviceViewController!)
            return
        }
        guard let month = dateComponents[0], let day = dateComponents[1], let year = dateComponents[2] else {
            AlertControllerUtilities.somethingWentWrong(with: serviceViewController!)
            return
        }
        var serviceToUpdate = serviceViewController!.service!
        serviceToUpdate = serviceToUpdate.setMonth(month)
        serviceToUpdate = serviceToUpdate.setDay(day)
        serviceToUpdate = serviceToUpdate.setYear(year)
        serviceViewController!.service = serviceToUpdate
        print("New Date:- \(date)")
    }
}
class DateTableViewCell: UITableViewCell  {
    public var date:String? {
        didSet {
            dateLabel.text = date
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    
}
