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
    
    var entryTemplate: EntryTemplate = EntryTemplate(name: "", macros: Macros(fats: 0, carbs: 0, proteins: 0)) {
        didSet {
            if (view != nil) {
               entryChanged()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (entryTemplate.id != nil) {
            self.title = "Edit Entry Template"
            deleteButton.isEnabled = true
        }
        entryChanged()
    }

    private func entryChanged() {
        if (!nameTextField.isEditing) {
            nameTextField.text = entryTemplate.name.description
        }
        if (!fatTextField.isEditing) {
            fatTextField.text = entryTemplate.fats.description
        }
        if (!carbsTextField.isEditing) {
            carbsTextField.text = entryTemplate.carbs.description
        }
        if (!proteinTextField.isEditing) {
            proteinTextField.text = entryTemplate.proteins.description
        }
        if (!caloriesTextField.isEditing) {
            caloriesTextField.text = entryTemplate.calories.description
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        if entryTemplate.id != nil {
            appDelegate.repository?.update(entryTemplate)
        } else {
            appDelegate.repository?.create(entryTemplate)
        }
        self.view.isUserInteractionEnabled = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        appDelegate.repository?.delete(entryTemplate)
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
    
    @IBAction func onNameEditingChanged(_ textField: UITextField) {
        if let value = textField.text {
            self.entryTemplate.name = value
        } else {
            self.entryTemplate.name = ""
        }
    }
    
    @IBAction func onFatEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entryTemplate.fats = value
        } else {
            self.entryTemplate.fats = 0
        }
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entryTemplate.carbs = value
        } else {
            self.entryTemplate.carbs = 0
        }
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entryTemplate.proteins = value
        } else {
            self.entryTemplate.proteins = 0
        }
    }
    
    @IBAction func onCaloriesEditingChanged(_ textField: UITextField) {
        
    }

    
}
