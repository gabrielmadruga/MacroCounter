//
//  AddEditEntryViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

class AddEditEntryViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var servingsTextField: UITextField!
    @IBOutlet weak var saveAsFavouriteSwitch: UISwitch!
    
    var entry: Entry = Entry(fat: 0, carbs: 0, protein: 0, servings: 1) {
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
        dateTextField.delegate = self
    }

    private func entryChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateTextField.text = dateFormatter.string(from: entry.date)
        if (!fatTextField.isEditing) {
            fatTextField.text = entry.fat.description
        }
        if (!carbsTextField.isEditing) {
            carbsTextField.text = entry.carbs.description
        }
        if (!proteinTextField.isEditing) {
            proteinTextField.text = entry.protein.description
        }
        if (!caloriesTextField.isEditing) {
            caloriesTextField.text = entry.calories.description
        }
        if (!servingsTextField.isEditing) {
            servingsTextField.text = entry.servings.description
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        if (entry.id != nil) {
            appDelegate.repository?.update(entry: entry)
        } else {
            appDelegate.repository?.create(entry: &entry)
        }
        self.view.isUserInteractionEnabled = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        appDelegate.repository?.delete(entry: &entry)
        self.view.isUserInteractionEnabled = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                dateTextField.becomeFirstResponder()
                break
            default:
                return
            }
            break
        case 1:
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
        case 2:
            servingsTextField.becomeFirstResponder()
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
        
        if (textField == dateTextField) {
            let alert = UIAlertController(title: "Date",
                                          message: "Select the day and time you ate this",
                                          preferredStyle: .actionSheet)
            let today = Date.init()
            self.entry.date = today
            alert.addDatePicker(mode: .dateAndTime, date: today, minimumDate: nil, maximumDate: today) { date in
                self.entry.date = date
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
        if (textField == dateTextField) {
            return
        }
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == dateTextField) {
            return
        }
        entryChanged()
    }
    
    @IBAction func onFatEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            self.entry.fat = value
        } else {
            self.entry.fat = 0
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
            self.entry.protein = value
        } else {
            self.entry.protein = 0
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
