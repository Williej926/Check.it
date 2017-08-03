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
    
    
    @IBOutlet weak var gradientView: GradientView!


    @IBOutlet weak var tableview: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        newTasks.sort(by:{$0.priority > $1.priority })

        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TaskCell
        if((newTasks[indexPath.row].title) != nil){
            if(Int(indexPath.row) < tasks.count){
                cell.taskName.text = newTasks[indexPath.row].title
                let date = newTasks[indexPath.row].endDate as! Date
                if(date.interval(ofComponent: .day, fromDate: Date()) == 0){
                    cell.dayLabel.text = "Task due today"
                }
                else{
                    cell.dayLabel.text = "Task due in \(date.interval(ofComponent: .day, fromDate: Date())) days"
                }
                
            }
           
            
        }
        
        print(newTasks)

        
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return newTasks.count
        
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
        print(tasks.count)
        print(newTasks.count)
        gradientView.addSubview(DayName)
        
        gradientView.mask = DayName
        gradientView.backgroundColor = UIColor.white


        

        
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
        var newPriority: String = ""
        switch task.priority{
        case 0:
            newPriority = "Low"
        case 1:
            newPriority = "Neutral"
        case 2:
            newPriority = "High"
        case 3:
            newPriority = "Urgent"
        default:
            newPriority = "Neutral"
            
        }
        popOverVC.priorityText = newPriority
        print(newPriority)
        
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
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
            //for taskIndex in 0...tasks.count - 1{
            var taskIndex = 0
            while taskIndex < tasks.count {
                
                if newTasks[indexPath.row] == tasks[taskIndex] {
                    delegate?.didDeleteTask(task: tasks[taskIndex])

                    CoreDataHelper.delete(task: tasks[taskIndex])

                    tasks.remove(at: taskIndex)
                   newTasks.remove(at: indexPath.row)
                    
                }

                taskIndex += 1
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
        switch task.priority{
        case 0:
            popOverVC.priorityText = "Low"
        case 1:
            popOverVC.priorityText = "Neutral"
        case 2:
            popOverVC.priorityText = "High"
        case 3:
            popOverVC.priorityText = "Urgent"
        default:
            popOverVC.priorityText = "Neutral"
            
        }

        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)



        
    
   

    
    }
}
