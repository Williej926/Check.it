//
//  NavigationController.swift
//  TImeManagment
//
//  Created by Willie Jiang on 8/3/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit
class NavigationController: UINavigationItem, UIViewControllerTransitioningDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.white
    }
    
}
