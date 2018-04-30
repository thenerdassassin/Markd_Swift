//
//  MarkdHeaderViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/28/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class MarkdHeaderViewController:UIViewController {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var leftTitle:String?
    var rightTitle:String?
    var leftAction: ((UIButton) -> Void)?
    var rightAction: ((UIButton) -> Void)?
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        configureView()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
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
        leftAction = nil
        rightAction = nil
        configureView()
    }
    public func configureHeader(useLeft leftTitle:String, onLeftClick leftAction: @escaping ((UIButton) -> Void), useRight rightTitle: String, onRightClick rightAction: @escaping ((UIButton) -> Void)) {
        self.leftTitle = leftTitle
        self.leftAction = leftAction
        self.rightTitle = rightTitle
        self.rightAction = rightAction
        configureView()
    }
    
    public func configureHeader(useRight rightTitle: String, onRightClick rightAction: @escaping ((UIButton) -> Void)) {
        self.rightTitle = rightTitle
        self.rightAction = rightAction
        configureView()
    }
    
    public func configureHeader(useLeft leftTitle:String, onLeftClick leftAction: @escaping ((UIButton) -> Void)) {
        self.leftTitle = leftTitle
        self.leftAction = leftAction
        configureView()
    }
}
