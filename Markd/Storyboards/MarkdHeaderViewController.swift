//
//  MarkdHeaderViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/28/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public protocol MarkdHeaderButtonDelegate {
    func leftButtonClicked(_ sender:UIButton)
    func rightButtonClicked(_ sender:UIButton)
}
public class MarkdHeaderViewController:UIViewController {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var leftTitle:String?
    var rightTitle:String?
    var delegate:MarkdHeaderButtonDelegate?
    @IBAction func leftClick(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.leftButtonClicked(sender)
        }
    }
    @IBAction func rightClick(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.rightButtonClicked(sender)
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        configureView()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public func configureView() {
        if let leftButton = leftButton {
            if leftTitle == nil {
                leftButton.isEnabled = false
                leftButton.isHidden = true
            } else {
                leftButton.titleLabel?.text = leftTitle
            }
        }
        if let rightButton = rightButton {
            if rightTitle == nil {
                rightButton.isEnabled = false
                rightButton.isHidden = true
            } else {
                rightButton.titleLabel?.text = rightTitle
            }
        }
    }
    
    var TODO_ImplementHeaderViewController🤬:AnyObject?
    public func configureHeader() {
        leftTitle = nil
        rightTitle = nil
        configureView()
    }
    public func configureHeader(useLeft leftTitle:String, useRight rightTitle: String, for delegate:MarkdHeaderButtonDelegate) {
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.delegate = delegate
        configureView()
    }
    
    public func configureHeader(useRight rightTitle: String, for delegate:MarkdHeaderButtonDelegate) {
        self.rightTitle = rightTitle
        self.delegate = delegate
        configureView()
    }
    
    public func configureHeader(useLeft leftTitle:String, for delegate:MarkdHeaderButtonDelegate) {
        self.leftTitle = leftTitle
        self.delegate = delegate
        configureView()
    }
}
