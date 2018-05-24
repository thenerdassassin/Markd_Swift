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
    
    var paintingSurfacesViewController: PaintingSurfacesViewController?
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
        if segue.identifier == "paintingSurfacesSegue" {
            let destination = segue.destination as! PaintingSurfacesViewController
            self.paintingSurfacesViewController = destination
            destination.customerData = customerData
            return
        }
        if segue.identifier == "painterFooterSegue" {
            let destination = segue.destination as! ContractorFooterViewController
            self.painterFooterViewController = destination
            return
        }
        if segue.identifier == "addPaintingSurfaceSegue" {
            let sender = sender as! UIAlertAction
            let destination = segue.destination as! EditPaintingSurfaceViewController
            guard let customerData = customerData else {
                AlertControllerUtilities.somethingWentWrong(with: self)
                return
            }
            customerData.removeListeners()
            destination.customerData = customerData
            if sender.title == "Interior" {
                destination.isInterior = true
            }
            destination.paintSurfaceIndex = -1
            let newPaintSurface = PaintSurface()
            destination.paintSurface = newPaintSurface
            return
        }
    }
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        var TODO_ChangeRootViewToElectrical🤪:AnyClass?
        let alert = UIAlertController(title: "Switch Page", message: "Which page would you like to switch to?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Plumbing", style: .default, handler: { _ in
            NSLog("Switching to Plumbing Page")
            if let navigationController = self.navigationController {
                let plumbingViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "PlumbingViewController") as! PlumbingViewController
                navigationController.setViewControllers([plumbingViewController], animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Hvac", style: .default, handler: { _ in
            NSLog("Switching to Hvac Page")
            if let navigationController = self.navigationController {
                let hvacViewController = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "HvacViewController") as! HvacViewController
                navigationController.setViewControllers([hvacViewController], animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Electrical", style: .default, handler: { _ in
            NSLog("Switching to Electrical Page")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            NSLog("Cancel page switch")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onAddPaintSurfaceAction(_ sender: Any) {
        AlertControllerUtilities.showActionSheet(
            withTitle: "Add Paint Surface",
            andMessage: "What type of paint surfice is being added?",
            withOptions: [
                UIAlertAction(title: "Interior", style: .default, handler: addPaintSurfaceHandler),
                UIAlertAction(title: "Exterior", style: .default, handler: addPaintSurfaceHandler),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ],
            in: self
        )
    }
    func addPaintSurfaceHandler(alert: UIAlertAction!) {
        if alert.title != nil && alert.title != "Cancel" {
            self.performSegue(withIdentifier: "addPaintingSurfaceSegue", sender: alert)
        }
    }
    //Mark: OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("PaintingViewController:- Got Customer Data")
        customerData!.getPainter(painterListener: painterFooterViewController)
        if let controller = paintingSurfacesViewController {
            controller.customerData = customerData
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
