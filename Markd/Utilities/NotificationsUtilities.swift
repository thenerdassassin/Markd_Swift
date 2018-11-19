//
//  NotificationsUtilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 6/2/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import Firebase
public class NotificationsUtilities {
    public static func getNotifications(for customerId:String, with listener:@escaping (DataSnapshot) -> Void) -> Bool {
        if(StringUtilities.isNilOrEmpty(customerId)) {
            return false
        }
        let reference = Database.database().reference().child("notifications").child(customerId);
        reference.observe(.value, with: listener)
        return true
    }
    
    public static func setNotifications(for customerId:String, to notifications:[CustomerNotificationMessage]) {
        let reference = Database.database().reference().child("notifications").child(customerId);
        let notifications = notifications.sorted()
        var notificationsArray = NSArray()
        for notification in notifications {
            notificationsArray = notificationsArray.adding(notification.toDictionary()) as NSArray
        }
        reference.setValue(notificationsArray)
    }
    
    public static func sendNotification(from company:String, with message: String, to customerId:String, successHandler: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        let notificationDictionary:[String:AnyObject] = [
            "dateSent":StringUtilities.getCurrentDateString() as AnyObject,
            "companyFrom":company as AnyObject,
            "message":message as AnyObject
        ]
        let newNotification = CustomerNotificationMessage(notificationDictionary)
        let notificationMessages = Database.database().reference().child("notifications").child(customerId);
        notificationMessages.observeSingleEvent(
            of: .value,
            with: { (snapshot) in
                if let dictionary = snapshot.value as? NSArray {
                    var notifications = createNotificationsArray(from: dictionary)
                    notifications.insert(newNotification, at: 0)
                    notificationMessages.setValue(convertArray(notifications))
                    successHandler()
                } else {
                    errorHandler(MarkdError.UnexpectedNil)
                }
            }, withCancel: errorHandler)
    }
    public static func sendNotifications(from company:String, with message: String, to customers:[String], successHandler:@escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        for customerId in customers {
            sendNotification(from: company, with: message, to: customerId, successHandler: successHandler, errorHandler: errorHandler)
        }
    }
    
    private static func createNotificationsArray(from array: NSArray) -> [CustomerNotificationMessage] {
        var notifications:[CustomerNotificationMessage] = []
        for notification in array {
            if let notificationDictionary = notification as? Dictionary<String, AnyObject> {
                notifications.append(CustomerNotificationMessage(notificationDictionary))
            }
        }
        return notifications
    }
    
    private static func convertArray(_ array:[CustomerNotificationMessage]) -> NSArray {
        var notificationsArray = NSArray()
        for notification in array {
            notificationsArray = notificationsArray.adding(notification.toDictionary()) as NSArray
        }
        return notificationsArray
    }
}
