//
//  ServieFileViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 9/29/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Foundation
import PDFKit
import FirebaseStorage

class ServieFileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OnGetDataListener {
    private let authentication = FirebaseAuthentication.sharedInstance
    var customerData:TempCustomerData?
    var serviceType:String?
    var serviceIndex:Int?
    var service:ContractorService? {
        didSet {
            if let index = fileIndex, let service = service {
                self.file = service.getFiles()[index]
            }
        }
    }
    var fileIndex:Int? {
        didSet {
            if let index = fileIndex, let service = service {
                self.file = service.getFiles()[index]
            }
        }
    }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(authentication.checkLogin(self)) {
            customerData = TempCustomerData(self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let customerData = customerData, let type = serviceType, let index = serviceIndex, let service = service, let fileNumber = fileIndex, let updatedFile = file {
            var files = service.getFiles()
            files[fileNumber] = updatedFile
            customerData.update(service.setFiles(files), index, of: type)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
        if let customerData = customerData {
            customerData.removeListeners()
        }
    }

    private func configureView() {
        print("Calling Configure View")
        if let file = file, let uid = authentication.getCurrentUser()?.uid, let _ = fileImageView {
            if(StringUtilities.isNilOrEmpty(file.getFileName())) {
                file.setFileName(to: "File \(fileIndex != nil ? String(fileIndex! + 1) :"")")
            }
            self.navigationItem.title = file.getFileName()
            
            animate()
            getMetaData(for: "images/services/\(uid)/\(file.getGuid())")
        } else if let fileImageView = fileImageView {
            fileImageView.kf.setImage(with: nil, placeholder: self.placeholderImage)
        }
    }
    func getMetaData(for filePath:String) {
        let storage = Storage.storage().reference(withPath: filePath)
        // Get metadata properties
        storage.getMetadata { metadata, error in
            guard error == nil else {
                self.endAnimate()
                self.fileImageView.isHidden = false
                self.fileImageView.kf.setImage(with: nil, placeholder: self.placeholderImage)
                return
            }
            guard let metadata = metadata else {
                self.endAnimate()
                self.fileImageView.isHidden = false
                self.fileImageView.kf.setImage(with: nil, placeholder: self.placeholderImage)
                return
            }
            if(metadata.contentType == "image/jpeg") {
                self.loadImage(from: storage)
            } else if(metadata.contentType == "application/pdf") {
                //TODO: load pdf
                self.loadPDF(from: storage)
            } else {
                self.endAnimate()
                self.fileImageView.isHidden = false
                AlertControllerUtilities.somethingWentWrong(with: self)
            }
        }
    }
    func loadImage(from storage: StorageReference) {
        storage.downloadURL { url,error in
            guard error == nil else {
                self.endAnimate()
                self.fileImageView.isHidden = false
                self.fileImageView.kf.setImage(with: nil, placeholder: self.placeholderImage)
                return
            }
            guard let url = url else {
                self.endAnimate()
                self.fileImageView.isHidden = false
                self.fileImageView.kf.setImage(with: nil, placeholder: self.placeholderImage)
                return
            }
            self.setFileImage(with:url)
        }
    }
    func setFileImage(with url: URL?) {
        self.fileImageView.kf.setImage(with:url, completionHandler: { (image, error, cacheType, imageUrl) in
            self.endAnimate()
            self.fileImageView.isHidden = false
            if(image != nil) {
                self.fileImageView.contentMode = .scaleAspectFit
            } else {
                self.fileImageView.contentMode = .center
            }
        })
    }
    func loadPDF(from storage: StorageReference) {
        print("Loading PDF")
        if #available(iOS 11.0, *) {
            let pdfView: PDFView = PDFView(frame: self.view.frame)
            storage.downloadURL { (URL, error) -> Void in
                guard let URL = URL else {
                    // Handle any errors
                    print("URL not there")
                    return
                }
                guard error == nil else {
                    // Handle any errors
                    print("Error")
                    return
                }
                print("Got PDF")
                do {
                    let data = try Data(contentsOf: URL)
                    pdfView.document = PDFDocument(data: data)
                    pdfView.displayMode = .singlePageContinuous
                    pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    pdfView.autoScales = true
                    pdfView.displayDirection = .vertical
                    self.fileImageView.isHidden = true
                    self.view.addSubview(pdfView)
                } catch let err {
                    
                }
                self.endAnimate()
            }
        } else {
            // Fallback on earlier versions
            print("Older versions")
        }
    }
    
    @IBAction func editTitleAction(_ sender: UIBarButtonItem) {
        //From: https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        let alert = UIAlertController(title: "Change file name.", message: nil, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "File"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists.
            if(!StringUtilities.isNilOrEmpty(alert!.textFields![0].text)) {
                self.navigationItem.title = alert!.textFields![0].text
                self.file!.setFileName(to: self.navigationItem.title!)
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func fileImageTapGesture(_ sender: UITapGestureRecognizer) {
        PhotoUtilities(self).getImage()
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let uid = authentication.getCurrentUser()?.uid {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let fileReference = Storage.storage().reference(withPath: "images/services/\(uid)/\(file!.setGuid(to: nil))")
            let uploadImage = fileReference.putData(UIImagePNGRepresentation(pickedImage)!, metadata: metadata) { (metadata, error) in
                fileReference.downloadURL { (url, error) in
                    self.setFileImage(with:url)
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
        animate()
    }
    private func observeUploadError(_ snapshot:StorageTaskSnapshot) {
        print("Upload Error")
        endAnimate()
        fileImageView.isHidden = false
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
    private func animate() {
        activityIndicator.startAnimating()
        fileImageView.isHidden = true
        //pdfView.isHidden = true
    }
    private func endAnimate() {
        activityIndicator.stopAnimating()
    }
    
    //Mark: OnGetDataListener
    public func onStart() {
        print("Getting Customer Data")
    }
    
    public func onSuccess() {
        print("ServiceFileViewController:- Got Customer Data")
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
