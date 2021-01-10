//
//  SetGoalViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/21/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

extension DailyTargetViewController: FormViewControllerDelegate {
        
    func validate() -> Bool {
        return true
    }
    
    func delete() {
    }
    
}

class DailyTargetViewController: FormViewController, UITextFieldDelegate {
    

    @IBOutlet weak var fatTableViewCell: MacroTableViewCell!
    @IBOutlet weak var carbsTableViewCell: MacroTableViewCell!
    @IBOutlet weak var proteinTableViewCell: MacroTableViewCell!
    @IBOutlet weak var caloriesTableViewCell: MacroTableViewCell!
    @IBOutlet weak var teeLabel: UILabel!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var objectiveSegmentedControl: UISegmentedControl!
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var dietSegmentedControl: UISegmentedControl!
    @IBOutlet weak var proteinAmountSegmentedControl: UISegmentedControl!
    
    private var profile: Profile!
    private var dailyTarget: DailyTarget! {
        profile.dailyTarget
    }
    private var offset: Int = 0 {
        didSet {
            offsetStepper.value = Double(offset)
            if offset <= -10 {
                objectiveSegmentedControl.selectedSegmentIndex = 0
            } else if offset >= 10 {
                objectiveSegmentedControl.selectedSegmentIndex = 2
            } else {
                objectiveSegmentedControl.selectedSegmentIndex = 1
            }
            offsetLabel.text = "\(offset > 0 ? "+" : "")\(offset)"
        }
    }
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        if let profile = try? childContext.fetch(fetchRequest).first {
            self.profile = profile
            offset = Int(round(dailyTarget.calories - profile.tee))
            offset = offset - (offset % 10)
            self.reloadDietSegmentedControls()
            self.teeLabel.text = "\(Int(round(profile.tee)))"
            caloriesTableViewCell.setup(type: .calories, macroOwner: dailyTarget, calsCell: caloriesTableViewCell) { [unowned self] in
                self.offset = Int(round(self.dailyTarget.calories - profile.tee))
                self.reloadDietSegmentedControls()
            }
            fatTableViewCell.setup(type: .fats, macroOwner: dailyTarget, calsCell: caloriesTableViewCell) { [unowned self] in
                self.reloadDietSegmentedControls()
            }
            carbsTableViewCell.setup(type: .carbs, macroOwner: dailyTarget, calsCell: caloriesTableViewCell)  { [unowned self] in
                self.reloadDietSegmentedControls()
            }
            proteinTableViewCell.setup(type: .proteins, macroOwner: dailyTarget, calsCell: caloriesTableViewCell) { [unowned self] in
                self.reloadDietSegmentedControls()
            }
//            In case the values are not correctly initialized
            calculateDailyTarget()
            try! grandChildContext?.save()
            try! childContext.save()
            saveContext()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                caloriesTableViewCell.numberTextField.becomeFirstResponder()
            case 1:
                fatTableViewCell.numberTextField.becomeFirstResponder()
            case 2:
                carbsTableViewCell.numberTextField.becomeFirstResponder()
            case 3:
                proteinTableViewCell.numberTextField.becomeFirstResponder()
            default:
                return
            }
        default:
            return
        }
    }
    
    @IBAction func onOffsetChange(_ sender: UIStepper) {
        offset = Int(sender.value)
        calculateDailyTarget()
    }
    
    
    @IBAction func onObjectiveChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            offset = -300
        case 1:
            offset = 0
        case 2:
            offset = 300
        default:
            fatalError()
        }
        calculateDailyTarget()
    }
    
    @IBAction func onDietChange(_ sender: UISegmentedControl) {
        calculateDailyTarget()
    }
    
    private func reloadDietSegmentedControls() {
        func dietIndex() -> Int {
            var result = 1
            if dailyTarget.fats <= 50 {
                result = 0
            }
            if dailyTarget.carbs <= 50 {
                result = 2
            }
            let fatCalories = dailyTarget.fats * Macros.calsPerFat
            let carbsCalories = dailyTarget.carbs * Macros.calsPerCarb
            if abs(fatCalories - carbsCalories) < 100 {
                result = 1
            }
            return result
        }
        dietSegmentedControl.selectedSegmentIndex = dietIndex()
        
        if dailyTarget.proteins < 1.5 * profile.weight {
            proteinAmountSegmentedControl.selectedSegmentIndex  = 0
        } else if dailyTarget.proteins > 1.7 * profile.weight {
            proteinAmountSegmentedControl.selectedSegmentIndex = 2
        } else {
            proteinAmountSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    private func targetProt() -> Float {
        switch proteinAmountSegmentedControl.selectedSegmentIndex {
        case 0:
            return 0.8 * profile.weight
        case 1:
            return 1.6 * profile.weight
        case 2:
            return 2.0 * profile.weight
        default:
            fatalError()
        }
    }
    
    private func calculateDailyTarget() {
        let targetCals = profile.tee + Float(offset)
        caloriesTableViewCell.setValue(targetCals)
        caloriesTableViewCell.overrideButton.isHidden = true
        let targetProt = self.targetProt()
        proteinTableViewCell.setValue(targetProt)
        let calsWithoutProt = targetCals - (targetProt * Macros.calsPerProt)
        switch dietSegmentedControl.selectedSegmentIndex {
        case 0:
            fatTableViewCell.setValue(50)
            let remainingCals = calsWithoutProt - 50 * Macros.calsPerFat
            let neededCarbs = remainingCals / Macros.calsPerCarb
            carbsTableViewCell.setValue(neededCarbs)
        case 1:
            let calsForFatsAndCarbs = calsWithoutProt / 2
            fatTableViewCell.setValue(calsForFatsAndCarbs / Macros.calsPerFat)
            carbsTableViewCell.setValue(calsForFatsAndCarbs / Macros.calsPerCarb )
        case 2:
            carbsTableViewCell.setValue(50)
            let remainingCals = calsWithoutProt - 50 * Macros.calsPerCarb
            let neededFats = remainingCals / Macros.calsPerFat
            fatTableViewCell.setValue(neededFats)
        default:
            fatalError()
        }
        caloriesTableViewCell.reloadData()
        fatTableViewCell.reloadData()
        carbsTableViewCell.reloadData()
        proteinTableViewCell.reloadData()
    }
    
}
