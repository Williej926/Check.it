//
//  navBar.swift
//  TImeManagment
//
//  Created by Willie Jiang on 8/3/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import  UIKit
@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            navigationBar.barTintColor = newValue
        }
        get {
            guard  let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }
    
    @IBInspectable var tintColor: UIColor? {
        set {
            navigationBar.tintColor = newValue
        }
        get {
            guard  let color = navigationBar.tintColor else { return nil }
            return color
        }
    }
    
    @IBInspectable var titleColor: UIColor? {
        set {
            guard let color = newValue else { return }
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: color]
        }
        get {
            return navigationBar.titleTextAttributes?["NSForegroundColorAttributeName"] as? UIColor
        }
    }
}
