//
//  AddEditEntryViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

protocol AddEditEntryViewControllerDelegate: class {

    func didSaveEntry()
    func didDeleteEntry()
}

class AddEditEntryViewController: UITableViewController, UITextFieldDelegate {

    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var servingsTextField: UITextField!
    
    @IBOutlet weak var calculateCaloriesButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    weak var delegate: AddEditEntryViewControllerDelegate?
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.coreData.managedContext
        isModalInPresentation = true
        calculateCaloriesButton.isHidden = true
        nameTextField.addToolbar(tagsRange: 1..<5)
        fatTextField.addToolbar(tagsRange: 1..<5)
        carbsTextField.addToolbar(tagsRange: 1..<5)
        proteinTextField.addToolbar(tagsRange: 1..<5)
        servingsTextField.addToolbar(tagsRange: 1..<5, onDone: (target: self, action: #selector(saveButtonPressed(_:))))
        if let entry = self.entry {
            self.title = "Edit Entry"
            if !entry.macros.calories.isEqual(to: entry.calories) {
                overrideCalories()
            }
            deleteButton.isEnabled = true
        } else {
            entry = Entry.init(context: managedContext)
            entry!.date = .init()
            deleteButton.isEnabled = false
            nameTextField.becomeFirstResponder()
        }
        entryChanged()
        dateTextField.delegate = self
    }

    private func entryChanged() {
        guard let entry = self.entry else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateTextField.text = dateFormatter.string(from: entry.date!)
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
            if caloriesTextField.tag == -1 {
                self.entry!.calories = entry.macros.calories
            }
            caloriesTextField.text = entry.calories.description
        }
        if (!servingsTextField.isEditing) {
            servingsTextField.text = entry.servings.description
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if entry?.name == nil {
            showToast(message: "A name is required") { [unowned self] in
                self.nameTextField.becomeFirstResponder()
            }
            return
        }
        delegate?.didSaveEntry()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        managedContext.delete(entry!)
        delegate?.didDeleteEntry()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) { [unowned self] in
            #warning("This is bad. Stackoverflow says I should use other context and merge them at the end or blow it")
            if !self.deleteButton.isEnabled {
                self.managedContext.delete(self.entry!)
            }
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
                dateTextField.becomeFirstResponder()
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
        self.nameTextField.addToolbar(tagsRange: 1..<6)
        self.caloriesTextField.addToolbar(tagsRange: 1..<6)
        self.fatTextField.addToolbar(tagsRange: 1..<6)
        self.carbsTextField.addToolbar(tagsRange: 1..<6)
        self.proteinTextField.addToolbar(tagsRange: 1..<6)
        self.servingsTextField.addToolbar(tagsRange: 1..<6, onDone: (target: self, action: #selector(self.saveButtonPressed(_:))))
        self.calculateCaloriesButton.isHidden = false
    }
    
    @IBAction func undoOverrideCalories(_ sender: Any) {
        caloriesTextField.tag = -1
        fatTextField.tag -= 1
        carbsTextField.tag -= 1
        proteinTextField.tag -= 1
        servingsTextField.tag -= 1
        nameTextField.addToolbar(tagsRange: 1..<5)
        fatTextField.addToolbar(tagsRange: 1..<5)
        carbsTextField.addToolbar(tagsRange: 1..<5)
        proteinTextField.addToolbar(tagsRange: 1..<5)
        servingsTextField.addToolbar(tagsRange: 1..<5, onDone: (target: self, action: #selector(saveButtonPressed(_:))))
        self.calculateCaloriesButton.isHidden = true
        caloriesTextField.resignFirstResponder()
        entryChanged()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.nextButtonTapped()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == dateTextField) {
            DispatchQueue.main.async() {
               textField.resignFirstResponder()
            }
            let alert = UIAlertController(title: "Date",
                                          message: "Select the day and time you ate this",
                                          preferredStyle: .actionSheet)
            let today = Date.init()
            self.entry?.date = today
            alert.addDatePicker(mode: .dateAndTime, date: today, minimumDate: nil, maximumDate: today) {  [unowned self] date in
                self.entry?.date = date
                self.entryChanged()
            }
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            
            DispatchQueue.main.async() { [unowned self] in
               self.present(alert, animated: true)
            }
            
            return
        }
        if (textField == caloriesTextField) {
            if textField.tag == -1 {
                DispatchQueue.main.async() {
                   textField.resignFirstResponder()
                }
                let overrideAction = UIAlertAction(title: "Override", style: .destructive) { [unowned self] (action) in
                    self.overrideCalories()
                    textField.becomeFirstResponder()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                let alert = UIAlertController(title: nil, message: "Calories should be calculated from macros, do you want to override it with a custom value?", preferredStyle: .actionSheet)
                alert.addAction(overrideAction)
                alert.addAction(cancelAction)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [unowned self] in
                   self.present(alert, animated: true)
                }
                return
            }
        }
        
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        entryChanged()
    }
    
    @IBAction func onNameEditingChanged(_ textField: UITextField) {
        if let value = textField.text {
            self.entry?.name = value
        } else {
            self.entry?.name = ""
        }
    }
    
    @IBAction func onFatEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.fats = value
        } else {
            self.entry?.fats = 0
        }
        entryChanged()
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.carbs = value
        } else {
            self.entry?.carbs = 0
        }
        entryChanged()
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.proteins = value
        } else {
            self.entry?.proteins = 0
        }
        entryChanged()
    }
    
    @IBAction func onCaloriesEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.calories = value
        } else {
            self.entry?.calories = 0
        }
    }
    
    @IBAction func onServingsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.servings = value
        } else {
            self.entry?.servings = 0
        }
    }
    
}
