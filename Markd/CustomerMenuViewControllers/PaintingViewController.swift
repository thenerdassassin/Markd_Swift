//
//  PaintingViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 5/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class PaintingViewController:UITableViewController {
    private let authentication = FirebaseAuthentication.sharedInstance
    public var customerData:TempCustomerData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertMarkdLogo()
        if(authentication.checkLogin(self)) {
            //customerData = TempCustomerData(self)
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
    // MARK: - Table view data source
    override public func numberOfSections(in tableView: UITableView) -> Int {
        // Exterior, Interior Surfaces
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 2
        }
        return 0
    }
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Interior Surfaces"
        } else if section == 1 {
            return "Exterior Surfaces"
        } else {
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "testCell")!
        /*
        let serviceCell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! ServiceTableViewCell
        var service:ContractorService?
        serviceCell.tag = indexPath.section
        serviceCell.serviceIndex = indexPath.row
        
        if indexPath.section == 0 {
            service = interiorSurfaces?[indexPath.row]
        } else if indexPath.section == 1 {
            service = exteriorSurfaces?[indexPath.row]
        } } else {
            AlertControllerUtilities.somethingWentWrong(with: self)
        }
        
        if let service = service {
            serviceCell.service = service
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "serviceDefaultCell", for: indexPath) as! ServiceTableViewCell
        }
        
        return serviceCell
         */
    }
}
