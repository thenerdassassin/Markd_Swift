//
//  ContractorFooterViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/20/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

public class ContractorFooterViewController: UIViewController, OnGetContractorListener {
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    @IBOutlet weak var websiteLabel: UIButton!
    @IBOutlet weak var companyLogoImageView: UIImageView!
    
    private func configureView(with contractor: Contractor) {
        print(contractor)
        if let companyLabel = companyLabel, let phoneNumberLabel = phoneNumberLabel, let websiteLabel = websiteLabel {
            if let contractorDetails = contractor.getContractorDetails() {
                let attrs: [NSAttributedStringKey: Any] = [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.0),
                    NSAttributedStringKey.foregroundColor : UIColor.white,
                    NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
                ]
                companyLabel.text = contractorDetails.getCompanyName()
                let websiteUrl = contractorDetails.getWebsiteUrl()
                if StringUtilities.isNilOrEmpty(websiteUrl) {
                    websiteLabel.isUserInteractionEnabled = false
                } else {
                    websiteLabel.setAttributedTitle(NSAttributedString(string: websiteUrl, attributes: attrs), for: .normal)
                }
                if let phoneNumber = contractorDetails.getTelephoneNumber() {
                    if StringUtilities.isNilOrEmpty(phoneNumber) {
                        phoneNumberLabel.isUserInteractionEnabled = false
                    } else {
                        phoneNumberLabel.setAttributedTitle(NSAttributedString(string: phoneNumber, attributes: attrs), for: .normal)
                    }
                } else {
                    phoneNumberLabel.isUserInteractionEnabled = false
                }
            }
        }
        if let companyLogo = companyLogoImageView, let file = contractor.getContractorDetails()?.getWebsiteUrl() {
            print(file)
            let placeholderImage = UIImage(named: "ic_action_pages")!
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/markd-schmidt-happens.appspot.com/o/images%2Flogos%2Fs5VWMQvH17ZJnVqxtOkqvWpufmu2%2Fb79a0ef6-4d7d-41fe-b10d-e87c22eaaa43?alt=media&token=a1339f28-5da1-43b7-99f8-6018ab2cf6dd")
            companyLogo.kf.indicatorType = .activity
            companyLogo.kf.setImage(with:url, placeholder:placeholderImage)
        }
    }
    
    //Mark:- OnClick
    @IBAction func onPhoneNumberTouchUp(_ sender: UIButton) {
        let phoneNumber = StringUtilities.removeNonNumeric(from: sender.titleLabel!.text!)
        
        if let url = URL(string: "tel://\(phoneNumber)") {
            if(UIApplication.shared.canOpenURL(url)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    @IBAction func onWebsiteTouchUp(_ sender: UIButton) {
        guard let url = getWebsiteUrl(from: sender.titleLabel!.text!) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    private func getWebsiteUrl(from string:String) -> URL? {
        let charSet = NSMutableCharacterSet()
        charSet.formUnion(with: NSCharacterSet.urlHostAllowed)
        charSet.formUnion(with: NSCharacterSet.urlPathAllowed)
        charSet.formUnion(with: NSCharacterSet.urlQueryAllowed)
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: charSet as CharacterSet) else {
            return nil
        }
        return getUrl(from:encodedString)
        
    }
    private func getUrl(from websiteString:String) -> URL? {
        if(websiteString.hasPrefix("http://") || websiteString.hasPrefix("https://")) {
            return URL(string:websiteString)
        } else {
            return URL(string:"http://\(websiteString)")
        }
    }
    
    //Mark:- OnGetContractorListener
    public func onFinished(contractor: Contractor?) {
        print("ContractorGetDataListener:- Got Contractor Data")
        if let contractor = contractor {
            configureView(with: contractor)
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self)
    }
}
