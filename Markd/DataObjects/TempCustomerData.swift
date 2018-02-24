//
//  TempCustomerData.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import Firebase

public class TempCustomerData {
    private static let database:DatabaseReference = Database.database().reference().child("users");
    private static var customer: Customer?
    private var customerId: String?
    private var userReference: DatabaseReference?
    private var listener: OnGetDataListener?
    
    public init(_ getDataListener: OnGetDataListener?) {
        self.customerId = FirebaseAuthentication.sharedInstance.getCurrentUser() != nil ? FirebaseAuthentication.sharedInstance.getCurrentUser()!.uid : nil
        self.listener = getDataListener
        if let customerId = customerId {
            userReference = TempCustomerData.database.child(customerId)
            userReference?.observe(DataEventType.value, with: { (snapshot) in
                print("got data:", snapshot)
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    TempCustomerData.customer = Customer(dictionary)
                    if let listener = self.listener {
                        listener.onSuccess()
                    } else {
                        //TODO
                    }
                } else {
                    //TODO
                    TempCustomerData.customer = nil
                }
            }, withCancel: { (error) in
                print("got error", error)
                if let listener = self.listener {
                    listener.onFailure(error)
                }
            })
        } else {
            //TODO
        }
    }

    private func getCustomer() -> Customer? {
        return TempCustomerData.customer
    }
    
    private func updateCustomer(to customer: Customer) {
        if let userReference = userReference {
            userReference.setValue(customer)
        } else {
            //TODO
        }
    }
    
    //TODO: addContractorListener, attachListener, removeListener, getUid
    //TODO: homePage
    public func getName() -> String {
        if let customer = TempCustomerData.customer {
            return customer.getName()
        } else {
            return ""
        }
    }
    //TODO: plumbingPage
    //TODO: hvacPage
    //TODO: electricalPage
    //TODO: paintingPage
    //TODO: services
    //TODO: settingsPage
    //TODO: makeCustomer
    
}

