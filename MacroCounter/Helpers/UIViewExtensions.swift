//
//  UIViewExtensions.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/25/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func loadFromNib<T: UIView>() -> T? {
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            return nil
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        return view
    }
}

//
//
//@IBDesignable
//class DesignableView: UIView {
//}
//
//@IBDesignable
//class DesignableButton: UIButton {
//}
//
//@IBDesignable
//class DesignableLabel: UILabel {
//}
//
//extension UIView {
//
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderColor: UIColor? {
//        get {
//            if let color = layer.borderColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                layer.borderColor = color.cgColor
//            } else {
//                layer.borderColor = nil
//            }
//        }
//    }
//
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOpacity: Float {
//        get {
//            return layer.shadowOpacity
//        }
//        set {
//            layer.shadowOpacity = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowColor: UIColor? {
//        get {
//            if let color = layer.shadowColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                layer.shadowColor = color.cgColor
//            } else {
//                layer.shadowColor = nil
//            }
//        }
//    }
//    
//}
