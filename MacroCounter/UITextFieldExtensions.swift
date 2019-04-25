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
        if text.count > 1 && text.first == "0" {
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
    
}
