//
//  PhotoUtilities.swift
//  Markd
//
//  Created by Joshua Schmidt on 9/30/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVFoundation

public class PhotoUtilities {
    var delegate:UIImagePickerControllerDelegate & UINavigationControllerDelegate & UIViewController
    
    init(_ viewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate & UIViewController) {
        delegate = viewController
    }
    
    public func getImage(with actionSheetTitle: String) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            AlertControllerUtilities.showActionSheet(withTitle: actionSheetTitle, andMessage: nil,
                                                     withOptions: [
                                                        UIAlertAction(title: "Take Photo", style: .default, handler: checkCameraAuthorizationStatus),
                                                        UIAlertAction(title:"Select Photo", style: .default, handler: checkPhotoLibraryAuthorizationStatus),
                                                        UIAlertAction(title:"Cancel", style: .cancel, handler: nil)],
                                                     in: delegate)
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
            AlertControllerUtilities.showAlert(withTitle: "Permission Denied", andMessage: "Markd does not have permission to access camera.", withOptions: [
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
                UIAlertAction(title: "Go to Settings", style: .default, handler: {(_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in print("Settings opened: \(success)") })
                    }
                })
                ], in: delegate)
            
        case .restricted: // The user can't grant access due to restrictions.
            return;
                
        @unknown default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupImagePicker(with: .camera)
                }
            }
        }
    }
    private func checkPhotoLibraryAuthorizationStatus(alert:UIAlertAction? = nil) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited: // The user has previously granted access to the camera.
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
            AlertControllerUtilities.showAlert(withTitle: "Permission Denied", andMessage: "Markd does not have permission to access photos.", withOptions: [
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
                UIAlertAction(title: "Go to Settings", style: .default, handler: {(_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (_) in return } )
                    }
                })
                ], in: delegate)
            
        case .restricted: // The user can't grant access due to restrictions.
            return;
        
        @unknown default:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized{
                    self.setupImagePicker(with: .photoLibrary)
                } else {
                    return
                }
            }
        }
    }
    
    private func setupImagePicker(with sourceType:UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        delegate.present(imagePicker, animated: true, completion: nil)
    }
}
