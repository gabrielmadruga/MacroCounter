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
        if let profile = try! childContext.fetch(profileFetchRequest).first {
            self.profile = profile
        }
        
        birthdateTableViewCell.setupForBirthdate(initWith: profile.birthday!) { [unowned self] date in
            if self.profile.birthday! == date {
                return
            }
            self.profile.birthday = date
            self.reloadData()
        }
        sexTableViewCell.setupForSelection(label: "Sex", options: ["Male", "Female"], initWith: profile.isMale ? 0 : 1) { [unowned self] selectedIndex in
            let selectedMale = selectedIndex == 0
            if self.profile.isMale == selectedMale {
                return
            }
            self.profile.isMale = selectedMale
            self.reloadData()
        }
        heightTableViewCell.setupForInteger(label: "Height", from: 100, to: 250, unit: "cm", initWith: Int(profile.height)) { [unowned self] selectedInt in
            if self.profile.height == Int16(selectedInt) {
                return
            }
            self.profile.height = Int16(selectedInt)
            self.reloadData()
        }
        weightTableViewCell.setupForFloat(label: "Weight", from: 20, to: 200, unit: "kg", initWith: profile.currentWeight!.value) { [unowned self] selectedFloat in
            if self.profile.currentWeight?.value == selectedFloat {
                return
            }
            let weightSample = WeightSample(context: self.childContext)
            weightSample.date = Date()
            weightSample.value = selectedFloat
            self.profile.currentWeight = weightSample
            self.reloadData()
        }
        
        reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section > 0 {
//           return 30
//        } else {
//            return super.tableView(tableView, heightForHeaderInSection: section)
//        }
//    }

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
    
    private func reloadData() {
        palSegmentedControl.selectedSegmentIndex = Int(round((profile.physicalActivityLevel-1)/0.2 - 1))
        bmrLabel.text = "\(Int(round(profile.bmr)))"
        teeLabel.text = "\(Int(round(profile.tee)))"
    }
}
