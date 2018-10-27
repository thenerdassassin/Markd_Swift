//
//  ContractorMainViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 10/16/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class ContractorMainViewController: UIViewController, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var contractorData: TempContractorData?
    
    @IBOutlet weak var companyDetailsLabel: UILabel!
    
    @IBAction func onLogOut(_ sender: UIButton) {
        FirebaseAuthentication.sharedInstance.signOut(self)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ContractorMainViewController:- viewWillAppear")
        if authentication.checkLogin(self) {
            contractorData = TempContractorData(self)
        }
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !authentication.checkLogin(self) {
            performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        }
        configureView()
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false;
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let contractorData = contractorData {
            contractorData.removeListeners()
        }
    }
    
    func configureView() {
        if let contractorDetails = contractorData?.getContractorDetails(), let companyDetailsLabel = companyDetailsLabel {
            let attrString = NSMutableAttributedString(string: contractorDetails.description)
            let style = NSMutableParagraphStyle()
            //style.lineSpacing = 24 // change line spacing between paragraph like 36 or 48
            style.minimumLineHeight = 30 // change line spacing between each line like 30 or 40
            attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: contractorDetails.description.count))
            companyDetailsLabel.attributedText = attrString
        }
    }
    
    //Mark:- OnGetDataListener Implementation
    public func onStart() {
        print("Getting Contractor Data")
    }
    
    public func onSuccess() {
        print("ContractorMainViewController:- Got Contractor Data")
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
}
