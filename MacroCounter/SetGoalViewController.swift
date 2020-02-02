//
//  SetGoalViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/21/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

class SetGoalViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    
    
    private var settings: Settings! {
        didSet {
            settingsChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = (appDelegate.repository.read(Settings.self) as! [Settings]).first
        settingsChanged()
    }
    
    private func settingsChanged() {
        if (!fatTextField.isEditing) {
            fatTextField.text = settings.goals.fat.description
        }
        if (!carbsTextField.isEditing) {
             carbsTextField.text = settings.goals.carbs.description
        }
        if (!proteinTextField.isEditing) {
             proteinTextField.text = settings.goals.protein.description
        }
        if (!caloriesTextField.isEditing) {
            caloriesTextField.text = settings.goals.calories.description
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        appDelegate.repository?.update(settings!)
        self.view.isUserInteractionEnabled = true
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                fatTextField.becomeFirstResponder()
                break
            case 1:
                carbsTextField.becomeFirstResponder()
                break
            case 2:
                proteinTextField.becomeFirstResponder()
                break
            case 3:
                caloriesTextField.becomeFirstResponder()
                break
            default:
                return
            }
            break
        default:
            return
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.2, animations: {
            UIView.setAnimationCurve(.easeOut)
            textField.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }, completion: { finish in
            UIView.animate(withDuration: 0.3, animations: {
                UIView.setAnimationCurve(.easeInOut)
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
            settings.goals.fat = value
        } else {
            settings.goals.fat = 0
        }
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            settings.goals.carbs = value
        } else {
            settings.goals.carbs = 0
        }
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            settings.goals.protein = value
        } else {
            settings.goals.protein = 0
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


