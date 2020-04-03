//
//  MacroCell.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/2/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

class MacroTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var overrideButton: UIButton!
    weak var caloriesTableViewCell: MacroTableViewCell!
    
    private var macroOwner: HasMacros!
    private var type: MacroType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadFromNib()
        overrideButton.isHidden = true
        numberTextField.addTarget(self, action: #selector(onTextEditingChanged), for: .editingChanged)
    }

    func setup(type: MacroType, macroOwner: HasMacros, calsCell: MacroTableViewCell) {
        self.type = type
        self.macroOwner = macroOwner
        self.caloriesTableViewCell = calsCell
        setup()
        reloadData()
        if type == .calories {
            if !macroOwner.macros.calories.isEqual(to: macroOwner.calories) {
                overrideButton.isHidden = false
            }
        }
    }
    
    @objc func onTextEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            setValue(value)
        } else {
            setValue(0)
            textField.text = ""
        }
    }
    
    private func setValue(_ value: Float) {
        switch type {
        case .calories:
            macroOwner.calories = value
            overrideButton.isHidden = false
            return
        case .fats:
            macroOwner.fats = value
        case .carbs:
            macroOwner.carbs = value
        case .proteins:
            macroOwner.proteins = value
        default:
            fatalError()
        }
        reCalcCalsAndReloadIfNeeded()
    }
    private func reCalcCalsAndReloadIfNeeded() {
        if caloriesTableViewCell.overrideButton.isHidden {
            macroOwner.calories = macroOwner.macros.calories
            caloriesTableViewCell.reloadData()
        }
    }
    private func reloadData() {
        switch type {
        case .calories:
            numberTextField.text = Int(round(macroOwner.calories)).description
        case .fats:
            numberTextField.text = Int(round(macroOwner.fats)).description
        case .carbs:
            numberTextField.text = Int(round(macroOwner.carbs)).description
        case .proteins:
            numberTextField.text = Int(round(macroOwner.proteins)).description
        default:
            fatalError()
        }
    }
    private func setup() {
        switch type {
        case .calories:
            nameLabel.text = "Calories"
            unitLabel.text = "cal"
            numberTextField.tag = 1
        case .fats:
            nameLabel.text = "Fats"
            unitLabel.text = "g"
            numberTextField.tag = 2
        case .carbs:
            nameLabel.text = "Carbs"
            unitLabel.text = "g"
            numberTextField.tag = 3
        case .proteins:
            nameLabel.text = "Protein"
            unitLabel.text = "g"
            numberTextField.tag = 4
        default:
            fatalError()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        if let formVC = self.parentViewController as? FormViewController {
            formVC.setupKeyboardToolbar(for: textField)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadData()
    }
    
    @IBAction func undoOverrideCalories(_ sender: Any) {
        overrideButton.isHidden = true
        numberTextField.resignFirstResponder()        
        reCalcCalsAndReloadIfNeeded()
    }
}
