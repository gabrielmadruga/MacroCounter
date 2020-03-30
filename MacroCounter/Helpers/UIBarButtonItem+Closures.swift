//
//  UIBarButtonItem+Closures.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/29/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

private var closure_objc_key: UInt8 = 0

extension UIBarButtonItem {

    var closureHandler: (() -> ())? {
        get { return objc_getAssociatedObject(self, &closure_objc_key) as? () -> () }
        set { objc_setAssociatedObject(self, &closure_objc_key, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    @objc private func callClosureHandler() {
        closureHandler?()
    }
    /**
        Initializes a new item using the specified image, style and handler
     */
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, handler: (() -> Void)? = nil) {
        self.init(image: image, style: style, target: nil, action: #selector(callClosureHandler))
        self.target = self
        self.closureHandler = handler
    }

    /**
        Initializes a new item using the specified images, style and handler
     */
    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, handler: (() -> Void)? = nil) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: #selector(callClosureHandler))
        self.target = self
        self.closureHandler = handler
    }

    /**
        Initializes a new item using the specified title, style and handler
     */
    convenience init(title: String?, style: UIBarButtonItem.Style, handler: (() -> Void)? = nil) {
        self.init(title: title, style: style, target: nil, action: #selector(callClosureHandler))
        self.target = self
        self.closureHandler = handler
    }

    /**
        Initializes a new item containing the specified system item and using the specified handler
     */
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, handler: (() -> Void)? = nil) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: #selector(callClosureHandler))
        self.target = self
        self.closureHandler = handler
    }
}
