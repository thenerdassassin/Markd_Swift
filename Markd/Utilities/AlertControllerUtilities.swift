//
//  AlertControllerUtilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/15/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

public class AlertControllerUtilities {
    public static func somethingWentWrong(with viewController:UIViewController, because error:Error) {
        print(error)
        Crashlytics.sharedInstance().recordError(error)
        let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong! 😢", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    public static func showPurchaseAlert(in viewController: UIViewController & PurchaseHandler) {
        showAlert(
            withTitle: "Purchase Subscription",
            andMessage: "To send notifications to customers or log services done on customer's home a subscription is needed.\nAnnual Subscription costs\n$199.99 per year",
            withOptions: [
                UIAlertAction(title: "Not now", style: .cancel, handler: viewController.purchase),
                UIAlertAction(title: "Subscribe", style: .default, handler: viewController.purchase)
                ], in: viewController)
    }
    
    public static func showAlert(withTitle title: String, andMessage message: String?, withOptions actions:[UIAlertAction], in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        } 
        viewController.present(alert, animated: true)
    }
    
    public static func showActionSheet(withTitle title: String, andMessage message: String?, withOptions actions:[UIAlertAction], in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        viewController.present(alert, animated: true)
    }
}
