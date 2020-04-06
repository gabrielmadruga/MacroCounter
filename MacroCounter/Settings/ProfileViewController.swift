//
//  ProfileViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/4/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit


extension ProfileViewController: FormViewControllerDelegate {
    
    func validate() -> Bool {
        return true
    }
    
    func delete() {
        print("delete")
    }
}
    
class ProfileViewController: FormViewController {

    @IBOutlet weak var birthdateTableViewCell: FormTableViewCell!
    @IBOutlet weak var sexTableViewCell: FormTableViewCell!
    @IBOutlet weak var heightTableViewCell: FormTableViewCell!
    @IBOutlet weak var weightTableViewCell: FormTableViewCell!
    @IBOutlet weak var palSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bmrLabel: UILabel!
    @IBOutlet weak var teeLabel: UILabel!
    
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true

        
        
        birthdateTableViewCell.setupForBirthdate()
        sexTableViewCell.setupForSelection(label: "Sex", options: ["Male", "Female"])
        heightTableViewCell.setupForInteger(label: "Height", from: 100, to: 250, unit: "cm")
        weightTableViewCell.setupForFloat(label: "Weight", from: 20, to: 200, unit: "kg")
        
        bmrLabel.text = "-"
        teeLabel.text = "-"
    }

    @IBAction func onPalChange(_ sender: Any) {
    }
}
