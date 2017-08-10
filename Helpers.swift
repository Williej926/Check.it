//
//  DateHelper.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/18/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit
import CoreData
extension Date{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    

    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
            
            let currentCalendar = Calendar.current
            
            guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
            guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
            
            return end - start
        }
    
}

extension NSDate{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
    var startOfDay: NSDate {
        return NSCalendar.current.startOfDay(for: self as Date) as NSDate
    }
    
   
    
}

extension String{
    func isStringAnInt(string: String) -> Bool {
        return Int(string) == nil
    }

}
extension UIButton {
    
    override func makeCircle() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = true
    }
    
    override func makeCircleWithBorderColor(color: UIColor, width: CGFloat) {
        self.makeCircle()
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    
}
extension UIView {
    
    func makeCircle() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = true
    }
    
    func makeCircleWithBorderColor(color: UIColor, width: CGFloat) {
        self.makeCircle()
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    
}


class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    static func newTask() -> Task {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
        return task
    }
    static func saveTask() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    static func delete(task: Task) {
        managedContext.delete(task)
        saveTask()
    }
    static func retrieveTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
   
}
