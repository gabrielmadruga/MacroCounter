//
//  UITextFieldExtensions.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/21/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}

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
    
    func nextButtonTapped() {
        let nextTag = self.tag + 1
        let nextResponder = smartViewWithTag(nextTag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
    func previousButtonTapped() {
        let nextTag = self.tag - 1
        let nextResponder = smartViewWithTag(nextTag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
}
