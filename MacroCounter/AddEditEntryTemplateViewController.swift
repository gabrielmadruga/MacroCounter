//
//  AddEditEntryViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

class AddEditEntryTemplateViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    
    var entry: Entry = Entry(macros: Macros(fats: 0, carbs: 0, proteins: 0), servings: 1) {
        didSet {
            if (view != nil) {
               entryChanged()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (entry.id != nil) {
            self.title = "Edit Entry"
            deleteButton.isEnabled = true
        }
        entryChanged()
    }

    private func entryChanged() {
        if (!fatTextField.isEditing) {
            fatTextField.text = entry.fats.description
        }
        if (!carbsTextField.isEditing) {
            carbsTextField.text = entry.carbs.description
        }
        if (!proteinTextField.isEditing) {
            proteinTextField.text = entry.proteins.description
        }
        if (!caloriesTextField.isEditing) {
            caloriesTextField.text = entry.calories.description
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        if entry.id != nil {
            appDelegate.repository?.update(entry)
        } else {
            appDelegate.repository?.create(entry)
        }
        self.view.isUserInteractionEnabled = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        appDelegate.repository?.delete(entry)
        self.view.isUserInteractionEnabled = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                nameTextField.becomeFirstResponder()
            default:
                return
            }
        case 1:
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            fatTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        entryChanged()
    }
    
    @IBAction func onFatEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry.fats = value
        } else {
            self.entry.fats = 0
        }
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry.carbs = value
        } else {
            self.entry.carbs = 0
        }
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry.proteins = value
        } else {
            self.entry.proteins = 0
        }
    }
    
    @IBAction func onCaloriesEditingChanged(_ textField: UITextField) {
        
    }
    
    @IBAction func onServingsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry.servings = value
        } else {
            self.entry.servings = 0
        }
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
