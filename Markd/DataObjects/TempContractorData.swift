//
//  TempContractorData.swift
//  Markd
//
//  Created by Joshua Schmidt on 10/16/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import Firebase

public class TempContractorData:CustomStringConvertible {
    private static let database:DatabaseReference = Database.database().reference().child("users");
    private var contractor: Contractor?
    private var constractorId: String?
    private var userReference: DatabaseReference?
    private var listener: OnGetDataListener?
    private var handle: UInt?
    
    public func printContractor() {
        if let contractor = contractor {
            print(contractor.description)
        }
    }
    public init(_ getDataListener: OnGetDataListener?) {
        TempContractorData.database.keepSynced(true)
        self.constractorId = FirebaseAuthentication.sharedInstance.getCurrentUser()?.uid
        self.listener = getDataListener
        if let constractorId = constractorId {
            userReference = TempContractorData.database.child(constractorId)
            if let userReference = userReference {
                handle = userReference.observe(DataEventType.value, with: contractorSuccessListener, withCancel: contractorCancelListener)
            } else {
                print("No userReference")
            }
        } else {
            self.userReference = nil
            contractor = nil
            if let currentView = UIApplication.shared.keyWindow?.rootViewController {
                AlertControllerUtilities.somethingWentWrong(with: currentView, because: MarkdError.UnexpectedNil)
            }
        }
    }
    public init(_ getDataListener: OnGetDataListener?, create contractor:Contractor, at id: String) {
        TempContractorData.database.keepSynced(true)
        self.constractorId = id
        self.listener = getDataListener
        userReference = TempContractorData.database.child(constractorId!)
        updateContractor(to: contractor)
        handle = userReference!.observe(DataEventType.value, with: contractorSuccessListener, withCancel: contractorCancelListener)
    }
    
    public func removeListeners() {
        if let userReference = userReference, let handle = handle {
            userReference.removeObserver(withHandle: handle)
        }
    }
    
    private func contractorSuccessListener(_ snapshot:DataSnapshot) {
        if let dictionary = snapshot.value as? [String : AnyObject] {
            contractor = Contractor(dictionary)
            if let listener = self.listener {
                listener.onSuccess()
            } else {
                if let currentView = UIApplication.shared.keyWindow?.rootViewController {
                    AlertControllerUtilities.somethingWentWrong(with: currentView, because: MarkdError.UnexpectedNil)
                }
            }
        }
    }
    private func contractorCancelListener(_ error: Error) {
        print("got error", error)
        if let listener = self.listener {
            listener.onFailure(error)
        }
    }
    
    public func getUid() -> String? {
        return self.constractorId
    }
    private func getContractor() -> Contractor? {
        return contractor
    }
    private func updateContractor(to contractor: Contractor?) {
        if let userReference = userReference, let contractor = contractor {
            userReference.setValue(contractor.toDictionary())
        } else {
            if let currentView = UIApplication.shared.keyWindow?.rootViewController {
                AlertControllerUtilities.somethingWentWrong(with: currentView, because: MarkdError.UnexpectedNil)
            }
        }
    }
    
    //Mark:- Getters/Setters
    public func getContractorDetails() -> ContractorDetails? {
        return getContractor()?.getContractorDetails()
    }
}