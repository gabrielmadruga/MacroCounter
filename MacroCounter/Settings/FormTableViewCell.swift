//
//  FormTableViewCell.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/4/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

enum FormTableViewCellType {
    case birthdate
    case selection
    case integer
    case float
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private var type: FormTableViewCellType!
    private var options: [[String]]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadFromNib()
    }

    private var onBirthdateChange: ((Date) -> ())?
    func setupForBirthdate(initWith: Date, onChange: ((Date) -> ())?) {
        nameLabel.text = "Birthdate"
        self.type = .birthdate
        self.onBirthdateChange = onChange
        
        let ninetyYearsAgo = Calendar.current.date(byAdding: .year, value: -90, to: Date())
        let twelveYearsAgo = Calendar.current.date(byAdding: .year, value: -12, to: Date())
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = ninetyYearsAgo
        datePicker.maximumDate = twelveYearsAgo
        datePicker.date = initWith
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(onDatePickerChange(_:)), for: .valueChanged)
        textField.tintColor = .clear
        textField.inputView = datePicker
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        textField.text = formatter.string(from: datePicker.date)
    }

    private var onSelectionChange: ((Int) -> ())?
    func setupForSelection(label: String, options: [String], initWith: Int, onChange: ((Int) -> ())?) {
        nameLabel.text = label
        self.type = .selection
        self.options = [options]
        self.onSelectionChange = onChange
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        textField.tintColor = .clear
        textField.inputView = picker
        textField.text = options[initWith]
        picker.selectRow(initWith, inComponent: 0, animated: true)
        pickerView(picker, didSelectRow: initWith, inComponent: 0)
    }
    
    private var onIntegerChange: ((Int) -> ())?
    private var integerOptions: [Int]?
    func setupForInteger(label: String, from: Int, to: Int, unit: String, initWith: Int, onChange: ((Int) -> ())?) {
        nameLabel.text = label
        self.type = .integer
        self.onIntegerChange = onChange
        
        var initialIntegerOptionIndex: Int = 0
        integerOptions = [Int](from...to)
        options = [integerOptions!.enumerated().map({ (index, i) -> String in
            if i == initWith {
               initialIntegerOptionIndex = index
            }
            return "\(i) \(unit)"
        })]
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        textField.tintColor = .clear
        textField.inputView = picker
        textField.text = "\(initWith) \(unit)"
        picker.selectRow(initialIntegerOptionIndex, inComponent: 0, animated: true)
        pickerView(picker, didSelectRow: initialIntegerOptionIndex, inComponent: 0)
    }
    
    private var onFloatChange: ((Float) -> ())?
    private var floatOptions: [[Int]]?
    func setupForFloat(label: String, from: Int, to: Int, unit: String, initWith: Float, onChange: ((Float) -> ())?) {
        nameLabel.text = label
        self.type = .float
        self.onFloatChange = onChange
        
        var initialFloatOptionIndexes: [Int] = [0, 0]
        options = []
        floatOptions = []
        floatOptions!.append([Int](from...to))
        options.append(floatOptions![0].enumerated().map({ (index, i) -> String in
            if i == Int(initWith) {
               initialFloatOptionIndexes[0] = index
            }
            return "\(i)"
        }))
        floatOptions!.append([Int](0...9))
        options.append(floatOptions![1].enumerated().map({ (index, i) -> String in
            if i == Int(round((initWith - Float(Int(initWith)))*10)) {
               initialFloatOptionIndexes[1] = index
            }
            return ".\(i)"
        }))
        options.append(["kg"])
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        textField.tintColor = .clear
        textField.inputView = picker
        textField.text = "\(initWith) \(unit)"
        
        picker.selectRow(initialFloatOptionIndexes[0], inComponent: 0, animated: true)
        picker.selectRow(initialFloatOptionIndexes[1], inComponent: 1, animated: true)
        pickerView(picker, didSelectRow: initialFloatOptionIndexes[0], inComponent: 0)
        pickerView(picker, didSelectRow: initialFloatOptionIndexes[1], inComponent: 1)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var text = ""
        
        for i in 0..<options.count {
            if options.count > 1 && i == options.count - 1 {
                text += " "
            }
            text += options[i][pickerView.selectedRow(inComponent: i)]
        }
        
        textField.text = text
        
        switch type {
        case .selection:
            onSelectionChange?(row)
        case .integer:
            onIntegerChange?(integerOptions![row])
        case .float:
            let intComponent = floatOptions![0][pickerView.selectedRow(inComponent: 0)]
            let decimalComponent = floatOptions![1][pickerView.selectedRow(inComponent: 1)]
            let float = Float(intComponent) + Float(decimalComponent)*0.1
            onFloatChange?(float)
        default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if options.count > 1 {
            return 50
        }
        return 100
    }
    
    @objc
    private func onDatePickerChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        textField.text = formatter.string(from: sender.date)
        onBirthdateChange?(sender.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .systemBlue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = .label
    }
}
