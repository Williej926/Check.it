//
//  DayInfo.swift
//  TImeManagment
//
//  Created by Willie Jiang on 7/21/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

protocol DayInfoViewControllerDelegate {
    func didDeleteTask(task: Task)
}

class DayInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tasks = [Task]();
    var delegate: DayInfoViewControllerDelegate?


    @IBOutlet weak var tableview: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TaskCell
        if(Int(indexPath.row) < tasks.count){
            cell.taskName.text = tasks[indexPath.row].title
            cell.button.tag = indexPath.row
            cell.button.addTarget(self, action: Selector("showPopup"), for: UIControlEvents.touchUpOutside)

        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasks.count
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    var day: String = "";


    @IBOutlet weak var DayName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DayName.text = day
        self.tableview.delegate = self
        self.tableview.dataSource = self
        //Crashlytics.sharedInstance().crash()
        //navigationItem.setHidesBackButton(true, animated: true)

        

        
    }

    @IBAction func showPopup(_ sender: AnyObject) {
        let buttontag = sender.tag
   

        let task = tasks[buttontag!]
        

        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup") as! PopUpViewController
        popOverVC.taskTitle = task.title
        popOverVC.taskDescription = task.description
        popOverVC.taskDeadline = String(describing: task.endDate!)
        
        print("TaskTitle: \(popOverVC.taskTitle)")
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.didDeleteTask(task: tasks[indexPath.row])

        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            self.tableview.reloadData()
            
        }
    }
   


}
