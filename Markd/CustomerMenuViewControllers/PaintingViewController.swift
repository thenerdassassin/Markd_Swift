//
//  PaintingViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 5/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class PaintingViewController:UIViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData?
    
    var painterFooterViewController: OnGetContractorListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertMarkdLogo()
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    private func insertMarkdLogo() {
        let image : UIImage = UIImage(named: "whiteTransparentLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        self.navigationController!.navigationBar.setTitleVerticalPositionAdjustment(-3.0, for: .defaultPrompt)
    }

    //Mark:- Segue
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "painterFooterSegue" {
            let destination = segue.destination as! ContractorFooterViewController
            self.painterFooterViewController = destination
            return
        }
    }
    
    //Mark: OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("PaintingViewController:- Got Customer Data")
        customerData!.getPainter(painterListener: painterFooterViewController)
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
