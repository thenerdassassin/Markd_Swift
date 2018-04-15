//
//  ApplianceEditFieldViewController.swift
//  Markd
//
//  Created by Joshua Schmidt on 4/10/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import UIKit

public class EditApplianceFieldViewController: UIViewController, LifeSpanViewProtocol {
    private let authentication = FirebaseAuthentication.sharedInstance
    
    var applianceIndex: Int?
    var originalValue: String? {
        didSet {
            configureView()
        }
    }
    var delegate: EditApplianceTableViewController?
    var fieldEditing: String? {
        didSet {
            configureView()
        }
    }
  
    @IBOutlet weak var lifeSpanPicker: LifeSpanPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!authentication.checkLogin(self)) {
            print("Not logged in.")
        }
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTexture")!)
        
        if let lifeSpanPicker = lifeSpanPicker {
            lifeSpanPicker.dataSource = lifeSpanPicker
            lifeSpanPicker.delegate = lifeSpanPicker
            lifeSpanPicker.lifeSpanViewController = self
        }
        configureView()
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseAuthentication.sharedInstance.removeStateListener()
    }
    
    private func configureView() {
        if let text = originalValue, let textField = textField {
            updateTextField(to: text)
            if let field = fieldEditing {
                textField.placeholder = field.capitalized
                switch field.lowercased() {
                case "manufacturer":
                    self.title = "Edit Manufacturer"
                    textField.isEnabled = true
                    datePicker.isHidden = true
                    lifeSpanPicker.isHidden = true
                case "model":
                    self.title = "Edit Model"
                    textField.isEnabled = true
                    datePicker.isHidden = true
                    lifeSpanPicker.isHidden = true
                case "install date":
                    self.title = "Edit Install Date"
                    textField.isEnabled = false
                    datePicker.isHidden = false
                    lifeSpanPicker.isHidden = true
                    datePicker.maximumDate = Date() //maxDate = currentDate
                    setDatePicker(text)
                case "projected life span":
                    self.title = "Edit Life Span"
                    textField.isEnabled = false
                    datePicker.isHidden = true
                    lifeSpanPicker.isHidden = false
                    setLifeSpanPicker(text)
                default:
                    AlertControllerUtilities.somethingWentWrong(with: self)
                }
            }
        }
        
    }
    
    //Mark:- PickerView
    public func setLifeSpanPicker(_ lifeSpan: String?) {
        guard !StringUtilities.isNilOrEmpty(lifeSpan) else {
            print("Life Span was null or empty")
            return
        }
        
        guard let lifeSpanCompenents = lifeSpan?.split(separator: " ") else {
            print("Not able to get lifeSpanComponents")
            return
        }
        
        guard lifeSpanCompenents.count == 2 else {
            print("Number of Components was \(lifeSpanCompenents.count)")
            return
        }
        guard let lifeSpanValue = Int("\(lifeSpanCompenents[0])") else {
            print("LifeSpanValue not able to be initialized")
            return
        }
        lifeSpanPicker.selectRow(lifeSpanValue-1, inComponent: 0, animated: true)
        
        let lifeSpanUnits = String(lifeSpanCompenents[1])
        guard let unitsRow = lifeSpanPicker.pickerDictionary.index(where: { (key: String, value: Array<Int>) -> Bool in
            return key == lifeSpanUnits
        }) else {
            print("No matching units to \(lifeSpanUnits)")
            return
        }
        lifeSpanPicker.selectRow(unitsRow, inComponent: 1, animated: true)
    }
    
    public func setDatePicker(_ date: String?) {
        let components = StringUtilities.getComponentsFrom(dotFormmattedString: date)
        if let month = components[0], let day = components[1], let year = components[2] {
            var dateComponents = DateComponents()
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.year = year
            
            let userCalendar = Calendar.current
            guard let installDate = userCalendar.date(from: dateComponents) else {
                print("installDate is null")
                return
            }
            datePicker.setDate(installDate, animated: true)
        }
    }
    @IBAction func onDateChange(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy"
        updateTextField(to: dateFormatter.string(from: sender.date))
    }
    
    func updateTextField(to value: String) {
        textField.text = value
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if let text = textField.text, let delegate = delegate, let index = applianceIndex, let field = fieldEditing {
            delegate.change(field, at: index, to: text)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
