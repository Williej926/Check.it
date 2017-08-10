//
//  Day.swift
//  TImeManagment
//
//  Created by Willie Jiang on 7/20/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation

class Day {
    var date: Date?
    var tasks = [Task]()
    
    
    init (date: Date) {
        self.date = date
    }
    
    func getDayOfWeek() -> String {
        let day = date as! Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: day)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-M-EEEE-y"
        let str = formatter.string(from: yourDate!)
        let dateArray = str.components(separatedBy: "-")
        return dateArray[2]
    }
    func format() -> String{
        let day = date as! Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let myString = formatter.string(from: day)
        return myString

        
    }
                         
    func ifDateFeasible (startDate: Date, endDate: Date) -> Bool {
//        let end = date?.addingTimeInterval(24)
        let end = endDate + 86400
        
        let start = startDate - 86400
        if  date! <= end {
            return true
        }
        else {
            return false
        }
    }
}
