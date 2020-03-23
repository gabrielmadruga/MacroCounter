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

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var servingsTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    weak var delegate: AddEditEntryViewControllerDelegate?
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.entry == nil {
            let managedContext = appDelegate.persistentContainer.viewContext
            entry = Entry.init(context: managedContext)
            entry!.date = .init()
            deleteButton.isHidden = true
        } else {
            self.title = "Edit Entry"
            deleteButton.isHidden = false
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
            caloriesTextField.text = entry.calories.description
        }
        if (!servingsTextField.isEditing) {
            servingsTextField.text = entry.servings.description
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        try! appDelegate.persistentContainer.viewContext.save()
        delegate?.didSaveEntry()
//        if saveAsFavouriteSwitch.isOn {
//            let template = EntryTemplate(name: "TODO", macros: entry.macros)
//            appDelegate.repository?.create(template)
//        }
        self.view.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        appDelegate.persistentContainer.viewContext.delete(entry!)
        try! appDelegate.persistentContainer.viewContext.save()
        delegate?.didDeleteEntry()
        self.view.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        case 2:
            servingsTextField.becomeFirstResponder()
        default:
            return
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        UIView.animate(withDuration: 0.2, animations: {
//            textField.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        }, completion: { finish in
//            UIView.animate(withDuration: 0.3, animations: {
//                textField.superview?.backgroundColor = nil
//            })
//        })
        
        if (textField == dateTextField) {
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
            self.present(alert, animated: true, completion: nil)
            return false
        }
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
        self.entry!.calories = entry!.macros.calories
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
    }
    
    @IBAction func onCarbsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.carbs = value
        } else {
            self.entry?.carbs = 0
        }
    }
    
    @IBAction func onProteinEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.proteins = value
        } else {
            self.entry?.proteins = 0
        }
    }
    
    @IBAction func onCaloriesEditingChanged(_ textField: UITextField) {
        
    }
    
    @IBAction func onServingsEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry?.servings = value
        } else {
            self.entry?.servings = 0
        }
    }
    
    // MARK: - Navigation

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
