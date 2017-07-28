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
    var newTasks = [Task]();

    var delegate: DayInfoViewControllerDelegate?
    



    @IBOutlet weak var tableview: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        newTasks.sort(by:{$0.priority > $1.priority })

        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TaskCell
        if(Int(indexPath.row) < tasks.count){
            cell.taskName.text = newTasks[indexPath.row].title
            cell.dayLabel.text = "Deadline: \(newTasks[indexPath.row].endDate!.toString(dateFormat: "MM-dd-yyyy"))"
            
            

        }
        print(newTasks)

        
        
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
        
        newTasks = tasks
        


        

        
    }
    override func viewDidAppear(_ animated: Bool) {

    }

    @IBAction func showPopup(_ sender: AnyObject) {
        let buttontag = sender.tag
   

        let task = tasks[buttontag!]
        

        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup") as! PopUpViewController
        popOverVC.taskTitle = task.title!
        popOverVC.taskDescription = task.taskDescription!
        popOverVC.taskDeadline = String(describing: task.endDate!)
        
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.didDeleteTask(task: newTasks[indexPath.row])
        
        if editingStyle == .delete {
//            CoreDataHelper.delete(task: tasks[indexPath.row])
//            for newTaskIndex in 0..<newTasks.count{
//                for taskIndex in 0..<tasks.count{
//                    if(newTasks[newTaskIndex] == tasks[taskIndex]){
//                        CoreDataHelper.delete(task: tasks[taskIndex])
//                        tasks.remove(at: taskIndex)
//
//                        
//                    }
//                }
//            }
////            tasks.remove(at: indexPath.row)
            for taskIndex in 0..<tasks.count{
                if newTasks[indexPath.row] == tasks[taskIndex] {
                    CoreDataHelper.delete(task: tasks[taskIndex])
                    tasks.remove(at: taskIndex)
                    newTasks.remove(at: indexPath.row)
                    
                }
            }
            tasks = CoreDataHelper.retrieveTasks()
            self.tableview.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = newTasks[indexPath.row]
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup") as! PopUpViewController
        popOverVC.taskTitle = task.title!
        popOverVC.taskDescription = " Description: \(task.taskDescription!)"
        popOverVC.taskDeadline = "Deadline: \((task.endDate?.toString(dateFormat: "MM-dd-yyyy"))!)"

        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)



        
    
   

    
    }
}
