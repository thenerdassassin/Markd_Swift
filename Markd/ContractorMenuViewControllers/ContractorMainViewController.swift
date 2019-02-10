//
//  ContractorMainViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 10/16/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class ContractorMainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    private var contractorData: TempContractorData?
    private var logoImageExists = false
    
    let storage = Storage.storage()
    @IBOutlet weak var logoImage: UIImageView!
    let placeholderImage = UIImage(named: "ic_action_camera")!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyDetailsLabel: UILabel!

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
        if let contractorData = contractorData, let companyDetailsLabel = companyDetailsLabel {
            if let contractorDetails = contractorData.getContractorDetails() {
                let attrString = NSMutableAttributedString(string: contractorDetails.description)
                let style = NSMutableParagraphStyle()
                style.minimumLineHeight = 30 // change line spacing between each line like 30 or 40
                attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: contractorDetails.description.count))
                companyDetailsLabel.attributedText = attrString
            } else {
                AlertControllerUtilities.showAlert(withTitle: "Welcome to Markd 😃", andMessage: "First, let's get some info about your company.", withOptions: [UIAlertAction(title: "Ok", style: .default, handler: addCompanyInformation)], in: self)
                companyDetailsLabel.text = "Loading...."
            }
            
            if let fileName = contractorData.getLogoImageFileName() {
                storage.reference(withPath: "images/\(fileName)").downloadURL { url,error in
                    guard error == nil else {
                        self.logoImage.kf.setImage(with: nil, placeholder: self.placeholderImage)
                        return
                    }
                    guard let url = url else {
                        self.logoImageExists = false
                        self.logoImage.kf.setImage(with: nil, placeholder: self.placeholderImage)
                        return
                    }
                    self.logoImageExists = true
                    self.setLogoImage(with:url)
                }
            } else {
                self.logoImageExists = false
                logoImage.kf.setImage(with: nil, placeholder: placeholderImage)
            }
        }
    }
    
    func setLogoImage(with url: URL?) {
        logoImage.isHidden = true
        activityIndicator.startAnimating()
        self.logoImage.kf.setImage(with:url, completionHandler: {
            (image, error, cacheType, imageUrl) in
            self.activityIndicator.stopAnimating()
            self.logoImage.isHidden = false
            if(image != nil) {
                //self.homeImageExists = true
                self.logoImage.backgroundColor = UIColor.clear
                self.logoImage.contentMode = .scaleAspectFit
            } else {
                //self.homeImageExists = false
                self.logoImage.backgroundColor = UIColor.lightGray
                self.logoImage.contentMode = .center
            }
        })
    }
    
    //Mark:- UIImagePickerController
    @IBAction func logoImageTapped(_ sender: UITapGestureRecognizer) {
        if(!logoImageExists) {
            PhotoUtilities(self).getImage()
        }
    }
    @IBAction func logoImageLongPressed(_ sender: UILongPressGestureRecognizer) {
        PhotoUtilities(self).getImage()
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let logoImageRef = storage.reference().child("images").child(contractorData!.setLogoImageFileName()!)
            let imageToUpload = pickedImage.jpegData(compressionQuality: 0.5)
            let uploadImage = logoImageRef.putData(imageToUpload!, metadata: metadata) { (metadata, error) in
                logoImageRef.downloadURL { (url, error) in
                    self.setLogoImage(with:url)
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
        logoImage.isHidden = true
    }
    private func observeUploadError(_ snapshot:StorageTaskSnapshot) {
        activityIndicator.stopAnimating()
        logoImage.isHidden = false
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
    
    private func addCompanyInformation(_ action:UIAlertAction) {
        print("Go to EditLogoVC")
        performSegue(withIdentifier: "addCompanyInformationSegue", sender: self)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
