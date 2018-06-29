//
//  EditPanelViewController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 1/4/17.
//  Copyright © 2017 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
/*
class EditPanelViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var isMainPanel: UISwitch!
    @IBOutlet weak var panelAmperagePicker: PanelAmperagePicker!
    var panelAmperagePickerController = PanelAmperagePicker()
    @IBOutlet weak var manufacturerPicker: ManufacturerPicker!
    var manufacturerPickerController = ManufacturerPicker()
    
    var delegate: PanelEdit?
    var panel: Panel? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        configureView()
    }
    
    func configureView() {
        if let panel = panel, let isMainPanel = isMainPanel, let navigationBar = navigationBar, let panelAmperagePicker = panelAmperagePicker, let manufacturerPicker = manufacturerPicker {
            isMainPanel.isOn = panel.isMainPanel
            navigationBar.title = panel.panelTitle
            
            //Set Up Pickers
            panelAmperagePicker.delegate = panelAmperagePickerController
            panelAmperagePicker.dataSource = panelAmperagePickerController
            panelAmperagePickerController.isMainPanel = panel.isMainPanel
            panelAmperagePickerController.viewController = self
            panelAmperagePicker.selectRow(panel.amperage.hashValue, inComponent: 0, animated: true)
            
            manufacturerPicker.delegate = manufacturerPickerController
            manufacturerPickerController.dataSource = manufacturerPickerController
            manufacturerPickerController.viewController = self
            manufacturerPicker.selectRow(panel.manufacturer.hashValue, inComponent: 0, animated: true)
        }
    }
    
    //Mark:- Navigation Items
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        delegate!.editPanel(panel!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isMainPanelValueChanged(_ sender: UISwitch) {
        panel!.isMainPanel = sender.isOn
        panelAmperagePickerController.isMainPanel = sender.isOn
    }
}
*/
