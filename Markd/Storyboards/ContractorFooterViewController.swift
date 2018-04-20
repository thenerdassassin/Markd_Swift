//
//  ContractorFooterViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/20/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class ContractorFooterViewController: UIViewController, OnGetContractorListener {
    
    
    private func configureView(with contractor: Contractor) {
        var TODO_ImplementConfigureFooter😭:AnyObject?
        print(contractor)
    }
    public func onFinished(contractor: Contractor?) {
        print("ContractorGetDataListener:- Got Contractor Data")
        if let contractor = contractor {
            configureView(with: contractor)
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
