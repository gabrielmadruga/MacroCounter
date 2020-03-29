//
//  UITextFieldExtensions.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/21/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

extension UITextField {
    
    func parseFloatAndAdjust() -> Float? {
        guard var text = self.text, text.count > 0 else {
            return nil
        }
        if text == "." {
            self.text = "0."
            text = "0."
        }
        if text.count == 2 && text.first == "0" && text != "0." {
            self.text = String(text.dropFirst())
        }
        let splits = Array(text.split(separator: ".", maxSplits: 2, omittingEmptySubsequences: false))
        if (splits.count == 3) {
            text = splits.joined() + "."
            self.text = text
        }
        if let floatValue = NumberFormatter().number(from: text)?.floatValue {
            return floatValue
        } else {
            self.text = ""
            return nil
        }
    }
    

    func addToolbar(tagsRange: Range<Int>, onCancel: (target: Any, action: Selector)? = nil, onDone: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        var items = [UIBarButtonItem(title: "Close", style: .plain, target: onCancel.target, action: onCancel.action), UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)]
        if self.tag > 1 {
            let upButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(previousButtonTapped))
            items.append(upButton)
            let someSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
            someSpace.width = 32
            items.append(someSpace)
        }
        if tagsRange.contains(self.tag) {
            items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(nextButtonTapped)))
        } else {
            items.append(UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action))
        }
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = items
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
    }
    @objc func cancelButtonTapped() {
        self.resignFirstResponder()
    }
    
    func smartViewWithTag(_ tag: Int) -> UIView? {
        var currentView = self.superview
        while currentView != nil {
            let result = currentView?.viewWithTag(tag)
            if result != nil {
                return result
            } else {
                currentView = currentView?.superview
            }
        }
        return nil
    }
    
    @objc func nextButtonTapped() {
        let nextTag = self.tag + 1
        let nextResponder = smartViewWithTag(nextTag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
    @objc func previousButtonTapped() {
        let nextTag = self.tag - 1
        let nextResponder = smartViewWithTag(nextTag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }

}
