//
//  UIColorExtensions.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/13/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
