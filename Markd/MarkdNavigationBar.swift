//
//  MarkdNavigationBar.swift
//  Markd
//
//  Created by Joshua Schmidt on 3/15/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

class MarkdNavigationBar: UINavigationBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 160)
    }
    
    public func setUp() {
        if let logo = UIImage(named: "whiteTransparentLogo") {
            let imageView = UIImageView(image:logo)
            imageView.contentMode = .scaleAspectFit
            if let item = topItem {
                item.titleView = imageView
            }
        }
    }
}
