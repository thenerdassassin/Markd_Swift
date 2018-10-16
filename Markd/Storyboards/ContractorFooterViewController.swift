//
//  ContractorFooterViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/20/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit
import Kingfisher

public class ContractorFooterViewController: UIViewController, OnGetContractorListener {
    let storage = Storage.storage()
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    @IBOutlet weak var websiteLabel: UIButton!
    @IBOutlet weak var companyLogoImageView: UIImageView!
    
    private var noContractorText = "Find a Contractor"
    private func configureView() {
        if let companyLabel = companyLabel, let phoneNumberLabel = phoneNumberLabel, let websiteLabel = websiteLabel {
            companyLabel.isHidden = true
            
            phoneNumberLabel.isUserInteractionEnabled = true
            phoneNumberLabel.setAttributedTitle(NSAttributedString(string: noContractorText, attributes: [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, .foregroundColor: UIColor.white]), for: .normal)
            
            websiteLabel.isUserInteractionEnabled = false
            websiteLabel.isHidden = true
            companyLogoImageView.isUserInteractionEnabled = false
        }
    }
    private func configureView(with contractor: Contractor, at reference: String?) {
        if let companyLabel = companyLabel, let phoneNumberLabel = phoneNumberLabel, let websiteLabel = websiteLabel {
            if let contractorDetails = contractor.getContractorDetails() {
                let attrs: [NSAttributedStringKey: Any] = [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.0),
                    NSAttributedStringKey.foregroundColor : UIColor.white,
                    NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
                ]
                companyLabel.isHidden = false
                companyLabel.text = contractorDetails.getCompanyName()
                let websiteUrl = contractorDetails.getWebsiteUrl()
                if StringUtilities.isNilOrEmpty(websiteUrl) {
                    websiteLabel.isUserInteractionEnabled = false
                } else {
                    websiteLabel.isUserInteractionEnabled = true
                    websiteLabel.isHidden = false
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
            } else {
                websiteLabel.isUserInteractionEnabled = false
                phoneNumberLabel.isUserInteractionEnabled = false
            }
        }
        if let companyLogo = companyLogoImageView {
            let placeholderImage = UIImage(named: "ic_action_pages")!
            companyLogo.kf.indicatorType = .activity
            if let reference = reference {
                let pathReference = storage.reference(withPath: "images/logos/\(reference)/\(contractor.getLogoFileName())")
                pathReference.downloadURL { url,error in
                    companyLogo.kf.setImage(with:url, placeholder:placeholderImage)
                }
            } else {
                companyLogo.kf.setImage(with: nil, placeholder: placeholderImage)
            }
        }
    }
    
    //Mark:- OnClick
    @IBAction func onPhoneNumberTouchUp(_ sender: UIButton) {
        if sender.titleLabel?.text == noContractorText {
            print("Going to find a contractor view controller")
            let findContractorViewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "FindContractor")
            self.navigationController?.pushViewController(findContractorViewController, animated: true)
            return
        }
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
        print(url)
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
    public func onFinished(contractor: Contractor?, at reference: String?) {
        print("ContractorGetDataListener:- Got Contractor Data")
        if let contractor = contractor {
            configureView(with: contractor, at: reference)
        } else {
            configureView()
        }
    }
    
    public func onFailure(_ error: Error) {
        debugPrint(error)
        AlertControllerUtilities.somethingWentWrong(with: self, because: error)
    }
}
