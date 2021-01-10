//
//  AddEditEntryViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData
import Combine

extension AddEditEntryViewController: FormViewControllerDelegate {
        
    func validate() -> Bool {
        guard let name = entry?.name, !name.isEmpty else {
            showToast(message: "A name is required") { [unowned self] in
                self.nameTextField.becomeFirstResponder()
            }
            return false
        }
        return true
    }
    
    func delete() {
        self.childContext.delete(self.entry!)
        try! self.childContext.save()
        self.saveContext()
    }
    
    
}

class AddEditEntryViewController: FormViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var servingsTextField: UITextField!
    
    @IBOutlet weak var calculateCaloriesButton: UIButton!
    
    
    var date = Date()
    var entry: Entry?
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        
        calculateCaloriesButton.isHidden = true
        if entry == nil {
            self.navigationController?.isToolbarHidden = true
            setupGrandChildContext()
            entry = Entry(context: grandChildContext!)
            try! grandChildContext!.save()
        } else if let entry = childContext.object(with: self.entry!.objectID) as? Entry {
            self.entry = entry
            if !entry.macros.calories.isEqual(to: entry.calories) {
                overrideCalories()
            }
            date = entry.date!
        }
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if grandChildContext != nil {
//            nameTextField.becomeFirstResponder()
//        }
    }
    
    private func reloadData() {
        guard let entry = self.entry else {
            return
        }
        if datePicker.date != entry.date! {
            datePicker.date = entry.date!
        }
        if (!nameTextField.isEditing) {
            nameTextField.text = entry.name
        }
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
        if (!servingsTextField.isEditing) {
            servingsTextField.text = entry.servings.description
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                nameTextField.becomeFirstResponder()
            case 1:
                datePicker.becomeFirstResponder()
            default:
                return
            }
        case 1:
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
        case 2:
            servingsTextField.becomeFirstResponder()
        default:
            return
        }
    }
    
    func overrideCalories() {
        self.caloriesTextField.tag = self.nameTextField.tag + 1
        self.fatTextField.tag += 1
        self.carbsTextField.tag += 1
        self.proteinTextField.tag += 1
        self.servingsTextField.tag += 1
        self.calculateCaloriesButton.isHidden = false
    }
    
    @IBAction func undoOverrideCalories(_ sender: Any) {
        caloriesTextField.tag = -1
        fatTextField.tag -= 1
        carbsTextField.tag -= 1
        proteinTextField.tag -= 1
        servingsTextField.tag -= 1
        self.calculateCaloriesButton.isHidden = true
        caloriesTextField.resignFirstResponder()
        
        self.entry!.calories = entry!.macros.calories
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
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        self.entry?.date = datePicker.date
        self.reloadData()
    }
    
    @IBAction func onNameEditingChanged(_ textField: UITextField) {
        if let value = textField.text {
            self.entry?.name = value
        } else {
            self.entry?.name = ""
        }
        if caloriesTextField.tag == -1 {
            self.entry!.calories = entry!.macros.calories
        }
        reloadData()
    }
    
    @IBAction func onFatEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.fats = value
        } else {
            self.entry?.fats = 0
        }
        if caloriesTextField.tag == -1 {
            self.entry!.calories = entry!.macros.calories
        }
        reloadData()
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.carbs = value
        } else {
            self.entry?.carbs = 0
        }
        if caloriesTextField.tag == -1 {
            self.entry!.calories = entry!.macros.calories
        }
        reloadData()
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.proteins = value
        } else {
            self.entry?.proteins = 0
        }
        if caloriesTextField.tag == -1 {
            self.entry!.calories = entry!.macros.calories
        }
        reloadData()
    }
    
    @IBAction func onCaloriesEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.calories = value
        } else {
            self.entry?.calories = 0
        }
        reloadData()
    }
    
    @IBAction func onServingsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.servings = value
        } else {
            self.entry?.servings = 0
        }
        reloadData()
    }
    
}
