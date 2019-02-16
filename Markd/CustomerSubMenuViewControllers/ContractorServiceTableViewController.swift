//
//  ContractorServiceTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/28/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

class ContractorServiceTableViewController: UITableViewController, UIDocumentPickerDelegate {
    var datePickerVisible = false
    var delegate:ServiceHistoryViewController?
    var customerData:TempCustomerData?
    var serviceIndex: Int?
    var serviceType: String?
    var pdfUrl: URL?
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
                delegate?.customerData = customerData.update(service!, number, of: type)
                if let serviceCount = customerData.getServiceCount(of: type) {
                    serviceIndex = serviceCount - 1
                }
            } else {
                print("Number: \(number) changes to###\n\(service!)")
                delegate?.customerData = customerData.update(service!, number, of: type)
            }
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
        }
    }
    
    @IBAction func onAddFileAction(_ sender: UIBarButtonItem) {
        AlertControllerUtilities.showActionSheet(withTitle: "File Type", andMessage: "Which type of file would you like to attach to this service?",
                                                 withOptions: [UIAlertAction(title: "Photo", style: .default, handler: addFile),
                                                               UIAlertAction(title: "PDF", style: .default, handler: addFile),
                                                               UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                                 in: self)
        
    }
    
    //Mark:- Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("shouldPerformSegue")
        if(identifier == "showServiceFileSegue") {
            guard let _ = customerData?.getUid(), let service = service else {
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return false
            }
            if let sender = sender as? UITableViewCell {
                let files = service.getFiles()
                if(sender.tag < 0 || sender.tag >= files.count) {
                    return false
                }
            } else if let urlArray = sender as? Array<URL> {
                guard urlArray.count > 0 else {
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
            let destination = segue.destination as! ServiceFileViewController
            destination.serviceType = serviceType
            destination.serviceIndex = serviceIndex
            if let sender = sender as? UITableViewCell {
                destination.fileIndex = sender.tag
                destination.service = service
            } else {
                if let urls = sender as? Array<URL> {
                    destination.pdfUrl = urls[0]
                }
                var files = service!.getFiles()
                files.append(FirebaseFile([:]))
                destination.fileIndex = files.count-1
                destination.service = service!.setFiles(files)
            }
            destination.delegate = self
            destination.customerData = customerData
            customerData?.removeListeners()
        }
    }
    
    private func addFile(action:UIAlertAction) {
        if(action.title == "Photo") {
            if(shouldPerformSegue(withIdentifier: "showServiceFileSegue", sender: self)) {
                performSegue(withIdentifier: "showServiceFileSegue", sender: self)
            }
        } else if(action.title == "PDF") {
            getPdfFile()
        } else {
            AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnsupportedConfiguration)
        }
    }
    
    private func getPdfFile() {
        //https://medium.com/@santhosh3386/ios-document-picker-eae1d37aefea
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        if(shouldPerformSegue(withIdentifier: "showServiceFileSegue", sender: urls)) {
            performSegue(withIdentifier: "showServiceFileSegue", sender: urls)
        }
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
            tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: UITableView.RowAnimation.fade)
            datePickerVisible = true
            tableView.endUpdates()
        }
    }
    func hideDatePicker() {
        if(datePickerVisible) {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: 3, section: 0)], with: UITableView.RowAnimation.fade)
            datePickerVisible = false
            tableView.endUpdates()
        }
    }

    // Mark:- Files
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 1) {
            if let files = service?.getFiles() {
                return files.count > 0
            }
        }
        return false
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let customerData = customerData else {
                print("Customer Data not set")
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            guard let service = service, let index = serviceIndex, let type = serviceType else {
                print("Missing service information")
                AlertControllerUtilities.somethingWentWrong(with: self, because: MarkdError.UnexpectedNil)
                return
            }
            // Delete the row from the data source
            var files = service.getFiles()
            files.remove(at: indexPath.row)
            delegate?.customerData = customerData.update(service.setFiles(files), index, of: type)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            if(service.getFiles().count == 0) {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            tableView.endUpdates()
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
        let _ = serviceViewController!.service!.setContractor(textField.text!)
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
        let _ = serviceViewController!.service!.setComments(textView.text!)
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
            AlertControllerUtilities.somethingWentWrong(with: serviceViewController!, because: MarkdError.UnsupportedConfiguration)
            return
        }
        guard let month = dateComponents[0], let day = dateComponents[1], let year = dateComponents[2] else {
            AlertControllerUtilities.somethingWentWrong(with: serviceViewController!, because: MarkdError.UnexpectedNil)
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
