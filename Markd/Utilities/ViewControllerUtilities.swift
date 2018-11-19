//
//  ViewControllerUtilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 7/18/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class ViewControllerUtilities {
    public static func insertMarkdLogo(into viewController: UIViewController) {
        let image : UIImage = UIImage(named: "whiteTransparentLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        viewController.navigationItem.titleView = imageView
        viewController.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-3.0, for: .defaultPrompt)
    }
}
