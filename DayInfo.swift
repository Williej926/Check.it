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
    func didCheckTask(checked: Bool, index: Int, dayIndex: Int)
}


class DayInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tasks = [Task]();
    var newTasks = [Task]();
    var alertInput: Int?
    var dayIndex: Int?
    

    var delegate: DayInfoViewControllerDelegate?
    
    
    @IBOutlet weak var gradientView: GradientView!

    @IBOutlet weak var limitButton: UIButton!

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        newTasks.sort(by:{$0.priority > $1.priority })
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TaskCell
        
        
        let conversion = Date() as! NSDate
        let dateAtMidnight = conversion.startOfDay as! Date

        let oldDate = newTasks[indexPath.row].endDate as! Date
        
        if((newTasks[indexPath.row].isChecked?[dayIndex!])! == true){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark

            
        }
        
        if(oldDate < dateAtMidnight){
            newTasks.remove(at: indexPath.row)
        }
        else{
    
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
        self.view.addSubview(DayName)
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        DayName.widthAnchor.constraint(equalToConstant: 150).isActive = true

        gradientView.mask = DayName
        gradientView.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(back(sender: )))

        self.navigationItem.leftBarButtonItem = newBackButton
        
        

        
    }
    
    
    func back(sender: UIBarButtonItem){
        var tasks = CoreDataHelper.retrieveTasks()
        for index in 0..<self.newTasks.count{
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableview.cellForRow(at: indexPath)
            for newIndex in 0..<tasks.count{
                if(cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
                    if(tasks[newIndex] == self.newTasks[index]){
                        if(dayIndex! < (tasks[newIndex].isChecked?.count)!){
                        tasks[newIndex].isChecked?[dayIndex!] = true
                        delegate?.didCheckTask(checked: true, index: newIndex,dayIndex: dayIndex!)
                        print("Is checked \(true)")
                    }
                    }
                }
                else{
                    
                    if(tasks[newIndex] == self.newTasks[index] && dayIndex! < (tasks[newIndex].isChecked?.count)!){
                        tasks[newIndex].isChecked?[dayIndex!] = false
                        delegate?.didCheckTask(checked: false, index: newIndex, dayIndex: dayIndex!)
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
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
                    let cell = tableView.cellForRow(at: indexPath)
                    if(cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
                        cell?.accessoryType == UITableViewCellAccessoryType.none
                    }
                    if(indexPath.row+1 < newTasks.count){
                        newTasks[indexPath.row+1].isChecked?[dayIndex!] = false
                    }
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

//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        let cell = tableview.cellForRow(at: indexPath)
        if(cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell?.accessoryType = UITableViewCellAccessoryType.none
        
        }
        else{
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
 


        
    
   

    
    }
    
    @IBAction func unwindToDayInfoViewController(_ segue: UIStoryboardSegue) {
        
        //self.tasks = CoreDataHelper.retrieveTasks()
        
        
    }
    
  
}

