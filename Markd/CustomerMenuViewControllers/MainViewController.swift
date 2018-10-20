//
//  MainViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 2/24/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVFoundation
import Firebase

public class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var customerData: TempCustomerData?
    private var homeImageExists = false
    
    let storage = Storage.storage()
    @IBOutlet weak var homeImage: UIImageView!
    let placeholderImage = UIImage(named: "ic_action_camera")!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var preparedForLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var homeInformationLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtilities.insertMarkdLogo(into: self)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController:- viewWillAppear")
        if authentication.checkLogin(self) {
            customerData = TempCustomerData(self)
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
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }
    
    func configureView() {
        if let customerData = customerData, let preparedForLabel = preparedForLabel, let streetAddressLabel = streetAddressLabel, let homeInformationLabel = homeInformationLabel {
            preparedForLabel.text = "Prepared for \(customerData.getName())"
            if let streetAddress = customerData.getFormattedAddress(), let roomInformation = customerData.getRoomInformation(), let squareFootage = customerData.getSquareFootageString() {
                streetAddressLabel.text = "\(streetAddress)"
                homeInformationLabel.text = "\(roomInformation) \n\(squareFootage)"
            } else {
                AlertControllerUtilities.showAlert(withTitle: "Welcome to Markd 😃", andMessage: "First, let's get some info about your home.", withOptions: [UIAlertAction(title: "Ok", style: .default, handler: addHomeInformation)], in: self)
                streetAddressLabel.text = "Loading...."
                homeInformationLabel.text = "-- bathrooms -- bedrooms \n -- square feet"
            }
            if let fileName = customerData.getHomeImageFileName() {
                 storage.reference(withPath: "images/\(fileName)").downloadURL { url,error in
                    guard error == nil else {
                        self.homeImage.kf.setImage(with: nil, placeholder: self.placeholderImage)
                        return
                    }
                    guard let url = url else {
                        self.homeImageExists = false
                        self.homeImage.kf.setImage(with: nil, placeholder: self.placeholderImage)
                        return
                    }
                    self.homeImageExists = true
                    self.setHomeImage(with:url)
                 }
             } else {
                self.homeImageExists = false
                homeImage.kf.setImage(with: nil, placeholder: placeholderImage)
             }
        }
    }
    
    func setHomeImage(with url: URL?) {
        homeImage.isHidden = true
        activityIndicator.startAnimating()
        self.homeImage.kf.setImage(with:url, completionHandler: {
            (image, error, cacheType, imageUrl) in
            self.activityIndicator.stopAnimating()
            self.homeImage.isHidden = false
                if(image != nil) {
                    self.homeImageExists = true
                    self.homeImage.backgroundColor = UIColor.clear
                    self.homeImage.contentMode = .scaleAspectFit
                } else {
                    self.homeImageExists = false
                    self.homeImage.backgroundColor = UIColor.lightGray
                    self.homeImage.contentMode = .center
                }
        })
    }
    
    //Mark:- UIImagePickerController
    @IBAction func homeImageTapped(_ sender: UITapGestureRecognizer) {
        if(!homeImageExists) {
             PhotoUtilities(self).getImage()
        }
    }
    
    @IBAction func homeImageLongPressed(_ sender: UILongPressGestureRecognizer) {
        PhotoUtilities(self).getImage()
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let homeImageRef = storage.reference().child("images").child(customerData!.setHomeImageFileName()!)
            let uploadImage = homeImageRef.putData(UIImagePNGRepresentation(pickedImage)!, metadata: metadata) { (metadata, error) in
                homeImageRef.downloadURL { (url, error) in
                    self.setHomeImage(with:url)
                }
            }
            uploadImage.observe(.progress, handler: observeUploadProgress)
            uploadImage.observe(.failure, handler: observeUploadError)
        }
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Mark:- Upload Image Observers
    private func observeUploadProgress(_ snapshot:StorageTaskSnapshot) {
        activityIndicator.startAnimating()
        homeImage.isHidden = true
    }
    private func observeUploadError(_ snapshot:StorageTaskSnapshot) {
        activityIndicator.stopAnimating()
        homeImage.isHidden = false
        if let error = snapshot.error as NSError? {
            switch (StorageErrorCode(rawValue: error.code)!) {
                case .retryLimitExceeded:
                    AlertControllerUtilities.showAlert(withTitle: "Upload Error", andMessage: "Time limit exceeded",
                                                           withOptions: [UIAlertAction(title: "Try uploading again", style: .default, handler: nil)], in: self)
                    break
                default:
                    AlertControllerUtilities.showAlert(withTitle: "Upload Error", andMessage: "Something went wrong",
                                                       withOptions: [UIAlertAction(title: "Try uploading again", style: .default, handler: nil)], in: self)
                    break
            }
        }
    }
    
    private func addHomeInformation(_ action:UIAlertAction) {
        print("Go to EditHomeVC")
        performSegue(withIdentifier: "addHomeInformationSegue", sender: self)
    }
    //Mark:- OnGetDataListener Implementation
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("MainViewController:- Got Customer Data")
        configureView()
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
    }
}
