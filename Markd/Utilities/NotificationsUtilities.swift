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
    //TODO: sendNotificationns
    //TODO: sendNotifications
    public static func getNotifications(for customerId:String, with listener:@escaping (DataSnapshot) -> Void) -> Bool {
        if(StringUtilities.isNilOrEmpty(customerId)) {
            return false
        }
        let reference = Database.database().reference().child("notifications").child(customerId);
        reference.observe(DataEventType.value, with: listener)
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
}

/*
 //Mark:- Static methods
 public static void sendNotification(String customerId, final String message, final String companyFrom) {
    final DatabaseReference notificationMessages = FirebaseDatabase.getInstance().getReference("notifications/"+customerId);
    notificationMessages.addListenerForSingleValueEvent(new ValueEventListener() {
        @Override
        public void onDataChange(DataSnapshot dataSnapshot) {
            List<CustomerNotificationMessage> notifications = new ArrayList<>();
            for(DataSnapshot string: dataSnapshot.getChildren()) {
                notifications.add(string.getValue(CustomerNotificationMessage.class));
            }
            notifications.add(0, new CustomerNotificationMessage(companyFrom, message));
            notificationMessages.setValue(notifications);
        }
        @Override
        public void onCancelled(DatabaseError databaseError) {
            Log.e(TAG, databaseError.toString());
        }
    });
 }
 
 public static void sendNotifications(List<String> customers, final String message, final String companyFrom) {
    if(!StringUtilities.isNullOrEmpty(message) && !StringUtilities.isNullOrEmpty(companyFrom) && customers != null) {
        for (String customer : customers) {
            if (!StringUtilities.isNullOrEmpty(customer)) {
                sendNotification(customer, message, companyFrom);
            }
        }
    }
 }
 */
