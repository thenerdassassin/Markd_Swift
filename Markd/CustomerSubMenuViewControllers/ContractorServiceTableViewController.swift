//
//  ContractorServiceTableViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/28/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class ContractorServiceTableViewController: UITableViewController {
    private var contractor:String?
    private var comments:String?
    private var installDate:String?
    private var files:[AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 3
        } else if(section == 1) {
            guard let files = files else {
                return 0
            }
            return files.count
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "contractorTableCell", for: indexPath)
                // Configure the cell...
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath)
                // Configure the cell...
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
                // Configure the cell...
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "serviceFileTableCell", for: indexPath)
                // Configure the cell...
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceFileTableCell", for: indexPath)

        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
