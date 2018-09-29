//
//  ServieFileViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 9/29/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import FirebaseStorage

class ServieFileViewController: UIViewController {
    var uid:String?
    var file:FirebaseFile? {
        didSet {
            if let _ = file {
                configureView()
            }
        }
    }
    
    @IBOutlet weak var fileImageView: UIImageView!
    let placeholderImage = UIImage(named: "ic_action_camera")!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func configureView() {
        if let file = file, let uid = uid {
            self.navigationItem.title = file.getFileName()
            let storage = Storage.storage().reference(withPath: "images/services/\(uid)/\(file.getGuid())")
            fileImageView.isHidden = true
            activityIndicator.startAnimating()
            storage.downloadURL { url,error in
                guard error == nil, let url = url else {
                    self.activityIndicator.stopAnimating()
                    self.fileImageView.isHidden = false
                    self.fileImageView.backgroundColor = UIColor.lightGray
                    self.fileImageView.contentMode = .center
                    self.fileImageView.kf.setImage(with: nil, placeholder: self.placeholderImage)
                    return
                }
                self.setFileImage(with:url)
            }
        }
    }
    
    func setFileImage(with url: URL?) {
        self.fileImageView.kf.setImage(with:url, completionHandler: { (image, error, cacheType, imageUrl) in
            self.activityIndicator.stopAnimating()
            self.fileImageView.isHidden = false
            if(image != nil) {
                self.fileImageView.backgroundColor = UIColor.clear
                self.fileImageView.contentMode = .scaleAspectFit
            } else {
                self.fileImageView.backgroundColor = UIColor.lightGray
                self.fileImageView.contentMode = .center
            }
        })
    }
}
