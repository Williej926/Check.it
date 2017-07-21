//
//  createContactsViewController.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/17/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth.FIRUser
import FirebaseDatabase

class createContactsViewController: UIViewController{
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactID: UITextField!
    let firUser = Auth.auth().currentUser
    @IBAction func sendInfo(_ sender: Any) {
        UserService.createContact(firUser!, contactName: contactName.text!, contactID: contactID.text!){ (user) in
            guard let user = user else {
                // handle error
                return
            }

    }
}
}
