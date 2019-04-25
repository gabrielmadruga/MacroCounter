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
    
    private var settings: Settings? {
        didSet {
            settingsChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsChanged()
    }
    
    private func settingsChanged() {
        if (!fatTextField.isEditing) {
//             fatTextView.text = entry.fat.description
        }
        if (!carbsTextField.isEditing) {
//             carbsTextView.text = entry.carbs.description
        }
        if (!proteinTextField.isEditing) {
//             proteinTextView.text = entry.protein.description
        }
        if (!caloriesTextField.isEditing) {
//            caloriesTextView.text = entry.calories.description
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
//        appDelegate.repository?.create(entry: &entry)
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
            textField.superview?.backgroundColor = UIColor.lightGray
        }, completion: { finish in
            UIView.animate(withDuration: 0.2, animations: {
                UIView.setAnimationCurve(.easeOut)
                textField.superview?.backgroundColor = nil
            })
        })
        
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
//            self.entry.fat = value
        } else {
//            self.entry.fat = 0
        }
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
//            self.entry.carbs = value
        } else {
//            self.entry.carbs = 0
        }
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
//            self.entry.protein = value
        } else {
//            self.entry.protein = 0
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


