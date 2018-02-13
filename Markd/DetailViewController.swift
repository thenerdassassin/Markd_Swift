//
//  DetailViewController.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 1/4/17.
//  Copyright © 2017 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, BreakerEdit {
    @IBOutlet weak var breakerDescriptionLabel: UILabel!
    @IBOutlet weak var amperageLabel: UILabel!
    @IBOutlet weak var breakerTypeLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var breaker:Breaker? {
        didSet {
            configureView()
        }
    }
    var delegate: BreakerEdit?
    var nextBreakerIsDoublePole: Bool?
    
    override func viewDidLoad() {
        configureView()
    }
    
    func configureView() {
        if let breaker = breaker, let breakerDescriptionLabel = breakerDescriptionLabel, let amperageLabel = amperageLabel, let breakerTypeLabel = breakerTypeLabel, let navigationBar = navigationBar {
            breakerDescriptionLabel.text = breaker.breakerDescription
            amperageLabel.text = breaker.amperage.description
            breakerTypeLabel.text = breaker.breakerType.description
            navigationBar.title = "Breaker \(breaker.number)"
        }
    }
    
    //Mark:- Navigation Bar Items
    @IBAction func editClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "EditCurrentBreaker", sender: self)
    }
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Mark:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCurrentBreaker" {
            let destination = segue.destination as! EditBreakerViewController
            destination.breaker = breaker
            destination.delegate = self
            destination.nextBreakerIsDoublePole = false
            return
        }
    }
    
    //Mark:- Protocol
    func editBreaker(breakerDescription:String, amperage:BreakerAmperage, breakerType:BreakerType) {
        breakerDescriptionLabel.text = breakerDescription
        amperageLabel.text = amperage.description
        breakerTypeLabel.text = breakerType.description
        delegate?.editBreaker(breakerDescription: breakerDescription, amperage: amperage, breakerType: breakerType)
    }
    
    //Not possible to be used
    func addBreaker(breakerDescription: String, amperage: BreakerAmperage, breakerType: BreakerType) {
        return
    }
}
