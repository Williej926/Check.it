//
//  ServicesViewController.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/12/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import FacebookLogin
import FBSDKLoginKit

class ServicesViewController: UIViewController {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());

        let loginButton = FBSDKLoginButton()
        // Optional: Place the button in the center of your view.
        loginButton.center = view.center
        view.addSubview(loginButton as? UIView ?? UIView())
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        if let accessToken = FBSDKAccessToken.current() {
            //user is now logged in
        }

    }
    
    
  
}
