//
//  ProfileViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/4/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

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
    
    private var profile: Profile!
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        setupHideKeyboardOnTap()

        let profileFetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        if let profile = try! context.fetch(profileFetchRequest).first {
            self.profile = profile
        }
        
        birthdateTableViewCell.setupForBirthdate(initWith: profile.birthday!) { [unowned self] date in
            self.profile.birthday = date
            self.reloadData()
        }
        sexTableViewCell.setupForSelection(label: "Sex", options: ["Male", "Female"], initWith: profile.isMale ? 0 : 1) { [unowned self] selectedIndex in
            self.profile.isMale = selectedIndex == 0
            self.reloadData()
        }
        heightTableViewCell.setupForInteger(label: "Height", from: 100, to: 250, unit: "cm", initWith: Int(profile.height)) { [unowned self] selectedInt in
            self.profile.height = Int16(selectedInt)
            self.reloadData()
        }
        weightTableViewCell.setupForFloat(label: "Weight", from: 20, to: 200, unit: "kg", initWith: profile.currentWeight!.value) { [unowned self] selectedFloat in
            let weightSample = WeightSample(context: self.context)
            weightSample.date = Date()
            weightSample.value = selectedFloat
            self.profile.currentWeight = weightSample
            self.reloadData()
        }
        
        reloadData()
    }

    @IBAction func onPalChange(_ sender: UISegmentedControl) {
        profile.physicalActivityLevel = 1 + (Float(sender.selectedSegmentIndex+1)*0.2)
        reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FormTableViewCell {
            if cell.textField.isFirstResponder {
                cell.textField.resignFirstResponder()
            } else {
                cell.textField.becomeFirstResponder()
            }
        }
    }
    
    
    private func calculateBMR() -> Float {
//        Nowadays, the Mifflin-St Jeor equation is believed to give the most accurate result and, is therefore what we use in this app. This BMR formula is as follows:
        //BMR (kcal / day) = 10 * weight (kg) + 6.25 * height (cm) – 5 * age (y) + s (kcal / day),
        //where s is +5 for males and -161 for females.

        let s: Float = profile.isMale ? 5.0 : -161.0
        let age = Float(Calendar.current.dateComponents([.year], from: profile.birthday!, to: Date()).year!)
        let weight = profile.currentWeight!.value
        let weightComponent = Float(10.0 * weight)
        let heightComponent = 6.25 * Float(profile.height)
        let ageComponent = 5.0 * age
        return weightComponent + heightComponent - ageComponent + s
    }
    
    private func calculateTEE() -> Float {
        return calculateBMR() * profile.physicalActivityLevel
    }
    
    private func reloadData() {
        palSegmentedControl.selectedSegmentIndex = Int(round((profile.physicalActivityLevel-1)/0.2 - 1))
        bmrLabel.text = "\(Int(round(calculateBMR())))"
        teeLabel.text = "\(Int(round(calculateTEE())))"
    }
}
