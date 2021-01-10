//
//  FormViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/29/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData
import Combine


protocol FormViewControllerDelegate: class {
    func validate() -> Bool
    func delete()
}

class FormViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    weak var delegate: FormViewControllerDelegate!
    enum FormMode {
        case create
        case edit
    }
    private var barButtonsSubscription: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if delegate == nil {
            fatalError("The delegate of FormViewController must ve set before calling super.viewDidLoad()")
        }
        isModalInPresentation = true
        self.navigationController?.presentationController?.delegate = self
        addButtons()
    }
    
    func setupKeyboardToolbar(for textField: UITextField) {
        func getPrevious() -> UITextField? {
            if textField.tag > 1 {
                return self.view.viewWithTag(textField.tag - 1) as? UITextField
            }
            return nil
        }
        func getNext() -> UITextField? {
            if textField.tag > 0 {
                return self.view.viewWithTag(textField.tag + 1) as? UITextField
            }
            return nil
        }
        let previous = getPrevious()
        let next = getNext()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let upButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain) {
            previous?.becomeFirstResponder()
        }
        let downButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain)  {
            next?.becomeFirstResponder()
        }
        let doneButton = UIBarButtonItem(title: "Done", style: .done)  {
            textField.resignFirstResponder()
        }
        upButton.width = 88
        downButton.width = 88
        doneButton.width = 88
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [upButton]
        if previous == nil {
            toolbar.items = [flexSpace, downButton]
        } else if next != nil {
            toolbar.items = [flexSpace, upButton, downButton]
        } else {
            toolbar.items = [flexSpace, upButton, doneButton]
        }
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
    }
    
    private func addButtons() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done) { [unowned self] in
            self.saveButtonPressed()
        }
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash) { [unowned self] in
            self.deleteButtonPressed()
        }
        let someSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        if (self.presentingViewController != nil) {
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel) { [unowned self] in
                self.cancelButtonPressed()
            }
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationController?.isToolbarHidden = false
        self.toolbarItems = [someSpace, deleteButton, someSpace]
    }
    
    @objc
    func saveButtonPressed() {
        guard delegate.validate() else {
            return
        }
        try! grandChildContext?.save()
        try! childContext.save()
        saveContext()
        if (self.presentingViewController != nil) {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func deleteButtonPressed() {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] (action) in
            self.delegate.delete()
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        self.view.endEditing(true)
        if (self.presentingViewController != nil) {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        func userDidChanges() -> Bool {
            if let grandChildContext = self.grandChildContext {
                return grandChildContext.hasChanges
            } else {
                return childContext.hasChanges
            }
        }
        
        self.view.endEditing(true)
        
        if userDidChanges() {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { [unowned self] (action) in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
}
