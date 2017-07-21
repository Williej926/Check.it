//
//  File.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/12/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
class CreateUsernameViewController: UIViewController{
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else {
                // handle error
                return
            }
            
            User.setCurrent(user)
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
    
}
