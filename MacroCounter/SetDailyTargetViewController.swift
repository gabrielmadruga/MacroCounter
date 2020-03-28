//
//  SetGoalViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/21/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

class SetDailyTargetViewController: UITableViewController, UITextFieldDelegate {
        
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    
    
    private var settings: Settings!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        let settings = (try! context.fetch(fetchRequest)).first
        self.settings = settings
        settingsChanged()
    }
    
    private func settingsChanged() {
        if (!fatTextField.isEditing) {
            fatTextField.text = settings.dailyTarget?.fats.description
        }
        if (!carbsTextField.isEditing) {
             carbsTextField.text = settings.dailyTarget?.carbs.description
        }
        if (!proteinTextField.isEditing) {
             proteinTextField.text = settings.dailyTarget?.proteins.description
        }
        if (!caloriesTextField.isEditing) {
            caloriesTextField.text = settings.dailyTarget?.calories.description
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                fatTextField.becomeFirstResponder()
            case 1:
                carbsTextField.becomeFirstResponder()
            case 2:
                proteinTextField.becomeFirstResponder()
            case 3:
                caloriesTextField.becomeFirstResponder()
            default:
                return
            }
        default:
            return
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.2, animations: {
            textField.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }, completion: { finish in
            UIView.animate(withDuration: 0.3, animations: {
                textField.superview?.backgroundColor = nil
            })
        })
        
        if (textField == caloriesTextField) {
            self.view.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.showToast(message: "Calories are calculated automatically")
            }
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        settingsChanged()
    }
    
    @IBAction func onFatEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            settings.dailyTarget?.fats = value
        } else {
            settings.dailyTarget?.fats = 0
        }
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            settings.dailyTarget?.carbs = value
        } else {
            settings.dailyTarget?.carbs = 0
        }
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            settings.dailyTarget?.proteins = value
        } else {
            settings.dailyTarget?.proteins = 0
        }
    }
    
    @IBAction func onCaloriesEditingChanged(_ textField: UITextField) {
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


