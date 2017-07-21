//
//  WeeklyCalendarViewController.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/18/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit

class WeeklyCalendarViewController : UITableViewController{
    var tasks = [Task](){
        didSet{
            tableView.reloadData();
        }
    }
    var array = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var dates: [Day] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        for num in 0...7 {
            let day = Calendar.current.date(byAdding: .day, value: num, to: Date())!
            let date = Day(date: day)
            dates.append(date)
            print(date.getDayOfWeek())
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count;
        
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        let row = indexPath.row
        cell.day.text = dates[row].getDayOfWeek()
        
        for task in tasks{
            if dates[row].ifDateFalliable(startDate: Date(), endDate: task.endDate!) {
                cell.taskName.text = task.title
            }
            else{
                cell.taskName.text = ""
            }
        }

//        if(tasks.count != 0){
//            let task = tasks[0]
//            cell.taskName.text = task.title
//        }
    
        
        
        
        
        return cell
    }
   
    @IBAction func unwindToWeeklyCalendarViewController(_ segue: UIStoryboardSegue) {
        
        
        
    }
}

