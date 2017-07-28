//
//  WeeklyCalendarViewController.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/18/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class WeeklyCalendarViewController : UITableViewController{
    var tasks = [Task](){
        didSet{
            tableView.reloadData();
        }
    }
    @IBOutlet var tableview: UITableView!
    var array = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var dates: [Day] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = CoreDataHelper.retrieveTasks()

        
        for num in 0...7 {
            let day = Calendar.current.date(byAdding: .day, value: num, to: Date())!
            let date = Day(date: day)
            dates.append(date)
            print(date.getDayOfWeek())
            
        }


    }

    @IBOutlet weak var taskHours: UILabel!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count;
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        let row = indexPath.row
        cell.tag = row
        var sum : Int32 = 0;
        cell.day.text = dates[row].getDayOfWeek()
        if(indexPath.row == 0){
            cell.day.text = "Today"
        }
        if(indexPath.row == 1){
            cell.day.text = "Tomorrow"
        }
        
        for task in tasks   {
            if dates[row].ifDateFeasible(startDate: Date(), endDate: task.endDate! as Date) {
            
                cell.feasibleTasks.append(task)
                cell.taskName.text = "You have \(cell.feasibleTasks.count) tasks today."
                sum += task.timePerDay
                cell.actualTasks.append(task)
                
            }
            else{
                cell.taskName.text = cell.taskName.text
            }
            if(sum > 0){
                cell.taskTime.text = "You have \(sum) hours of work today"
            }
            
        }
        if(tasks.count == 0){
            cell.taskName.text = "You don't have any tasks today."
            cell.taskTime.text = ""
        }
        
        cell.feasibleTasks.removeAll()  

//        if(tasks.count != 0){
//            let task = tasks[0]
//            cell.taskName.text = task.title
//        }
    
        
        
        
        
        return cell
    }
   
    @IBAction func unwindToWeeklyCalendarViewController(_ segue: UIStoryboardSegue) {
        
        self.tasks = CoreDataHelper.retrieveTasks()

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let indexPath =  tableView.indexPathForSelectedRow!
            let day = dates[indexPath.row]

            let editDayViewController = segue.destination as! DayInfoViewController
            editDayViewController.day = day.getDayOfWeek()
           
            editDayViewController.delegate = self
            let taskcell = tableView(tableview, cellForRowAt: indexPath) as! Cell
            for index in 0..<taskcell.actualTasks.count{
                editDayViewController.tasks.append(taskcell.actualTasks[index])

            }
            taskcell.actualTasks.removeAll()



        }
    }
  
    
}

extension WeeklyCalendarViewController: DayInfoViewControllerDelegate {
    func didDeleteTask(task: Task) {
        tasks = tasks.filter() { $0 !== task }
        tableview.reloadData()
    }
}
