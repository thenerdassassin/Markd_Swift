//
//  NotificationsViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/2/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase

class NotificationsViewController: UITableViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var notifications:[CustomerNotificationMessage]? {
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertMarkdLogo()
        if(authentication.checkLogin(self)) {
            guard let userId = authentication.getCurrentUser()?.uid else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            if !NotificationsUtilities.getNotifications(for: userId, with: { (snapshot) in self.configureView(notifications: snapshot) }) {
                AlertControllerUtilities.somethingWentWrong(with: self)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
    }
    private func insertMarkdLogo() {
        let image : UIImage = UIImage(named: "whiteTransparentLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        self.navigationController!.navigationBar.setTitleVerticalPositionAdjustment(-3.0, for: .defaultPrompt)
    }
    private func configureView(notifications snapshot:DataSnapshot) {
        print(snapshot)
        if let notificationsArray = snapshot.value as? NSArray {
            var notifications = [CustomerNotificationMessage]()
            for notification in notificationsArray {
                if let notificationDictionary = notification as? Dictionary<String, AnyObject> {
                    notifications.append(CustomerNotificationMessage(notificationDictionary))
                }
            }
            self.notifications = notifications.sorted()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notifications = notifications {
            if notifications.count != 0 {
                return notifications.count
            }
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationCell
        if notifications != nil && notifications!.count != 0 {
            cell.notificationMessage = notifications![indexPath.row]
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "notificationDefaultCell", for: indexPath)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let notifications = notifications {
            return notifications.count != 0
        }
        return false
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notifications!.remove(at: indexPath.row)
            NotificationsUtilities.setNotifications(for: authentication.getCurrentUser()!.uid, to: self.notifications!)
        }
    }
}

public class NotificationCell:UITableViewCell {
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    public var notificationMessage:CustomerNotificationMessage? {
        didSet {
            companyLabel.text = notificationMessage!.getCompanyFrom()
            dateLabel.text = notificationMessage!.getDateSent()
            messageLabel.text = notificationMessage!.getMessage()
        }
    }
}
