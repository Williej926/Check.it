
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
    var gl:CAGradientLayer!

    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        var height = bounds.size.height

        super.viewDidLoad()
        tasks = CoreDataHelper.retrieveTasks()


        tableview.backgroundView = nil;
        tableview.backgroundView = UIView()

        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        
        self.gl.locations = [0.0, 1.0]
        for num in 0...7 {
            let day = Calendar.current.date(byAdding: .day, value: num, to: Date())!
            let date = Day(date: day)
            dates.append(date)
            print(date.getDayOfWeek())
            
        }
        gradientView.addSubview(navBarTitle)
        gradientView.mask = navBarTitle
        gradientView.backgroundColor = UIColor.white
        tableview.rowHeight = height / 9
        

        
        

     }

    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var taskHours: UILabel!
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count;
        
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        let row = indexPath.row
        cell.tag = row
        var sum : Int32 = 0;
        cell.day.text = dates[row].getDayOfWeek()
        cell.date.text = dates[row].format()
        if(indexPath.row == 0){
            cell.day.text = "Today"
        }
        if(indexPath.row == 1){
            cell.day.text = "Tomorrow"
        }
        var amount = 0

        
        for task in tasks   {
            if dates[row].ifDateFeasible(startDate: Date(), endDate: task.endDate! as Date) {
                cell.feasibleTasks.append(task)
                var count = 0;
                for index in 0..<cell.feasibleTasks.count{
                    if(cell.feasibleTasks[index].isChecked?[indexPath.row] == true){
                        count+=1
                    }
                    else{
                        sum += task.timePerDay

                    }
                }
                if(cell.feasibleTasks.count - count == 1){
                    cell.taskName.text = "You have one task today"
                }
                else{
                    cell.taskName.text = "You have \(cell.feasibleTasks.count - count) tasks today."
                }
                
                cell.actualTasks.append(task)


        
                
            }
            else{
                cell.taskName.text = cell.taskName.text
            }
            if(sum > 0){
                cell.taskTime.text = "You have \(sum) hours of work today"
            }
            var dateComponents  = DateComponents()
            dateComponents.day = row
            let offset = Calendar.current.date(byAdding: dateComponents , to: Date())
            if task.endDate?.toString(dateFormat: "MM-dd-yyyy") == offset?.toString(dateFormat: "MM-dd-yyyy"){
                amount += 1
                if(amount < 0){
                    cell.taskTime.text = "You don't have any tasks today."
                    CoreDataHelper.delete(task: task)
                }
                else{
                    cell.taskTime.text = "You have \(amount) tasks due \(cell.day.text!)"
                }
            }
        }
        
        if cell.feasibleTasks.count == 0 {
            cell.taskName.text = "You don't have any tasks today."
            cell.taskTime.text = ""
        }
//        if(tasks.count == 0){
//            cell.taskName.text = "You don't have any tasks today."
//            cell.taskTime.text = ""
//        }

    


//        if(tasks.count != 0){
//            let task = tasks[0]
//            cell.taskName.text = task.title
//        }
    
        
        cell.feasibleTasks.removeAll()

        
        
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
            editDayViewController.dayIndex = indexPath.row
            taskcell.actualTasks.removeAll()



        }
    }
  
    
}

extension WeeklyCalendarViewController: DayInfoViewControllerDelegate {
    func didDeleteTask(task: Task) {
        tasks = tasks.filter { $0 != task }
        tableview.reloadData()
    }
    func didCheckTask(checked: Bool, index: Int, dayIndex: Int){
        tasks[index].isChecked?[dayIndex] = checked
        tableview.reloadData()
    }
}
