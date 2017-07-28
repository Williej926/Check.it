//
//  PopUpViewController.swift
//  TImeManagment
//
//  Created by Willie Jiang on 7/24/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    var taskTitle = ""
    var taskDescription = ""
    var taskDeadline = ""
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet var textview: UITextView!
    
    @IBOutlet weak var actualPopup: UIView!
        override func viewDidLoad() {
            super.viewDidLoad()
            taskName.text = taskTitle
            textview.text = taskDescription
            deadline.text = taskDeadline;
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            actualPopup.layer.cornerRadius = 10;
            actualPopup.layer.masksToBounds = true;
            actualPopup.center = self.view.center;

            
            self.showAnimate()
            
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        @IBAction func closePopUp(_ sender: AnyObject) {
            self.removeAnimate()
            //self.view.removeFromSuperview()
        }
        
        func showAnimate()
        {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            });
            

        }
        
        func removeAnimate()
        {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
            });
        }
        
    
    

}

