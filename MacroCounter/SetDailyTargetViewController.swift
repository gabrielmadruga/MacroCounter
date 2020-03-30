//
//  SetGoalViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/21/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

extension SetDailyTargetViewController: FormViewControllerDelegate {
        
    func validate() -> Bool {
        return true
    }
    
    func delete() {
    }
    
}

class SetDailyTargetViewController: FormViewController, UITextFieldDelegate {
    

    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    
    @IBOutlet weak var calculateCaloriesButton: UIButton!
    
    private var dailyTarget: DailyTarget!
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        
        calculateCaloriesButton.isHidden = true        
        
        let fetchRequest: NSFetchRequest<DailyTarget> = DailyTarget.fetchRequest()
        if let dailyTarget = try? childContext.fetch(fetchRequest).first {
            self.dailyTarget = dailyTarget
            if !dailyTarget.macros.calories.isEqual(to: dailyTarget.calories) {
                overrideCalories()
            }
        }
        reloadData()
    }
    
    private func reloadData() {
        guard let dailyTarget = self.dailyTarget else {
            return
        }
        if (!fatTextField.isEditing) {
            fatTextField.text = dailyTarget.fats.description
        }
        if (!carbsTextField.isEditing) {
            carbsTextField.text = dailyTarget.carbs.description
        }
        if (!proteinTextField.isEditing) {
            proteinTextField.text = dailyTarget.proteins.description
        }
        if (!caloriesTextField.isEditing) {
            caloriesTextField.text = dailyTarget.calories.description
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                caloriesTextField.becomeFirstResponder()
            case 1:
                fatTextField.becomeFirstResponder()
            case 2:
                carbsTextField.becomeFirstResponder()
            case 3:
                proteinTextField.becomeFirstResponder()
            default:
                return
            }
        default:
            return
        }
    }
    
    func overrideCalories() {
        self.caloriesTextField.tag = 1
        self.calculateCaloriesButton.isHidden = false
    }
    
    @IBAction func undoOverrideCalories(_ sender: Any) {
        caloriesTextField.tag = -1
        self.calculateCaloriesButton.isHidden = true
        caloriesTextField.resignFirstResponder()
        
        self.dailyTarget!.calories = dailyTarget!.macros.calories
        reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.nextButtonTapped()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == caloriesTextField) {
            if textField.tag == -1 {
                DispatchQueue.main.async() {
                    textField.resignFirstResponder()
                }
                let alert = UIAlertController(title: nil, message: "Calories should be calculated from macros, do you want to override it with a custom value?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Override", style: .destructive) { [unowned self] (action) in
                    self.overrideCalories()
                    textField.becomeFirstResponder()
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [unowned self] in
                    self.present(alert, animated: true)
                }
                return
            }
        }
        setupKeyboardToolbar(for: textField)
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.reloadData()
    }
    
    @IBAction func onFatEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.dailyTarget?.fats = value
        } else {
            self.dailyTarget?.fats = 0
        }
        if caloriesTextField.tag == -1 {
            self.dailyTarget!.calories = dailyTarget!.macros.calories
        }
        reloadData()
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.dailyTarget?.carbs = value
        } else {
            self.dailyTarget?.carbs = 0
        }
        if caloriesTextField.tag == -1 {
            self.dailyTarget!.calories = dailyTarget!.macros.calories
        }
        reloadData()
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.dailyTarget?.proteins = value
        } else {
            self.dailyTarget?.proteins = 0
        }
        if caloriesTextField.tag == -1 {
            self.dailyTarget!.calories = dailyTarget!.macros.calories
        }
        reloadData()
    }
    
    @IBAction func onCaloriesEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.dailyTarget?.calories = value
        } else {
            self.dailyTarget?.calories = 0
        }
        reloadData()
    }
    
}
