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
        print("Bucket: \(storage.reference().bucket)")
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
                        //self.homeImageExists = false
                        //self.homeImage.backgroundColor = UIColor.lightGray
                        //self.homeImage.contentMode = .center
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
            getNewHomeImage()
        }
    }
    
    @IBAction func homeImageLongPressed(_ sender: UILongPressGestureRecognizer) {
        getNewHomeImage()
    }
    private func getNewHomeImage() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            AlertControllerUtilities.showActionSheet(withTitle: "Picture of your Home", andMessage: nil,
                                                     withOptions: [
                                                        UIAlertAction(title: "Take Photo", style: .default, handler: checkCameraAuthorizationStatus),
                                                        UIAlertAction(title:"Select Photo", style: .default, handler: checkPhotoLibraryAuthorizationStatus),
                                                        UIAlertAction(title:"Cancel", style: .cancel, handler: nil)],
                                                     in: self)
        } else {
            checkPhotoLibraryAuthorizationStatus()
        }
    }
    private func checkCameraAuthorizationStatus(alert: UIAlertAction!) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.setupImagePicker(with: .camera)
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupImagePicker(with: .camera)
                    }
                }
            
            case .denied: // The user has previously denied access.
                return
            case .restricted: // The user can't grant access due to restrictions.
                return
        }
    }
    private func checkPhotoLibraryAuthorizationStatus(alert:UIAlertAction? = nil) {
        switch PHPhotoLibrary.authorizationStatus() {
            case .authorized: // The user has previously granted access to the camera.
                self.setupImagePicker(with: .photoLibrary)
            
            case .notDetermined: // The user has not yet been asked for camera access.
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized{
                        self.setupImagePicker(with: .photoLibrary)
                    } else {
                        return
                    }
                }
            case .denied: // The user has previously denied access.
                return
            case .restricted: // The user can't grant access due to restrictions.
                return
        }
    }
    
    private func setupImagePicker(with sourceType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            //TODO:- Catch upload errors
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
