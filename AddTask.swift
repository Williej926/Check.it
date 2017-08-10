//
//  AddTask.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/18/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class AddTaskVC: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate,UITextFieldDelegate{
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var deadlinePicker: UITextField!
    @IBOutlet weak var PriorityPicker: UITextField!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var timePicker: UITextField!
    @IBOutlet weak var textview: UITextView!
    let priorityOptions = ["Low", "Neutral", "High", "Urgent"]
    let array = ["taskname","taskdescription","deadline","priority","estimated"]
    var selectedDate = Date()
    
    let task : Task? = nil
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    override func viewDidLoad() {
        let pickerView = UIPickerView()
        let hourPickerView = UIPickerView()
        pickerView.tag = 1
        hourPickerView.tag = 2
        timePicker.delegate = self
        
        pickerView.delegate = self
        
        PriorityPicker.inputView = pickerView
        let datePicker = UIDatePicker(frame: CGRect.zero)
//        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.onDatePickerValueChanged), for: .valueChanged)
        //let components = Calendar.dateComponents([.year, .month, .day, .hour], from: Date)
        
        
        deadlinePicker.inputView = datePicker
        deadlinePicker.text = String(describing: Date())
        let firstDate = datePicker.date.toString(dateFormat: "MM-dd-yyyy")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.date(from:firstDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        datePicker.minimumDate = calendar.startOfDay(for: calendar.date(from: components)!)
        datePicker.datePickerMode = .date
        datePicker.date = calendar.date(from: components)!
        deadlinePicker.text = datePicker.date.toString(dateFormat: "MM-dd-yyyy")
        
        
        textview.delegate = self;
        
        
        textview.text = "Enter Task Description Here"
        textview.textColor = UIColor.lightGray
        textview.clipsToBounds = true;
        textview.layer.cornerRadius = 10.0
   
               textview.delegate = self;

        
    }
    override func viewWillDisappear(_ animated: Bool) {


    }
    
    
   
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "cancel", sender: UIButton())
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Task Description Here"
            textView.textColor = UIColor.lightGray
        }
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func onDatePickerValueChanged(_ datePicker: UIDatePicker) {
        
        deadlinePicker.text = datePicker.date.toString(dateFormat: "MM-dd-yyyy")
        let isoDate = deadlinePicker.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.date(from:isoDate!)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        selectedDate = date
        
        self.view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityOptions.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return priorityOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        PriorityPicker.text = priorityOptions[row]
        self.view.endEditing(true)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    func updateTextField(_ sender: Any) {
        let picker: UIDatePicker? = (deadlinePicker.inputView as? UIDatePicker)
        deadlinePicker.text = "\(picker?.date)"
        
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath);
//        cell?.contentView.backgroundColor = UIColor.white
//    }
    
    @IBAction func save(_ sender: Any) {
        let time = timePicker.text!
        
        if (time == "" || (textview.text == "" || textview.text == "Enter Task Description Here" || textview.text == "Enter Task Description Here")){
            let alertController = UIAlertController(title: "Please enter missing information", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        else{
            let time = timePicker.text!
            let task = self.task ?? CoreDataHelper.newTask()
            task.title = taskTitle.text!
            task.endDate = selectedDate as NSDate!
            let endDate = task.endDate as Date!
            switch PriorityPicker.text ?? ""{
            case "Low":
                task.priority = 0
            case "Neutral":
                task.priority = 1
            case "High":
                task.priority = 2
            case "Urgent":
                task.priority = 3
            default:
                task.priority = 4
                
                
            }
            task.isChecked = [Bool]()
            
            for index in 0...endDate!.interval(ofComponent: .day, fromDate: Date()) + 1{
                print("checking task")
                task.isChecked!.append(false)
            }
            print(task.isChecked)

            if Int32(timePicker.text!) != nil{
                task.timeNeeded = Int32(timePicker.text!)!
                task.taskDescription = textview.text ?? ""
                

                if(((endDate?.interval(ofComponent: .day, fromDate: Date()))!) == 0){
                    task.timePerDay = task.timeNeeded/1
                }
                else{
                    task.timePerDay = task.timeNeeded/Int32((endDate?.interval(ofComponent: .day, fromDate: Date()))!)
                }
                if(deadlinePicker.text == endDate?.toString(dateFormat: "MM-dddd-yyyy")){
                    var date = Date() as NSDate
                    task.endDate = date.startOfDay
                        
                }
                if task.timePerDay > 8 {
                    print(true)
                    let alertController = UIAlertController(title: "Your task makes you work more than 8 hours a day", message: "Do you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
                        
                        
                    })
                    let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                        CoreDataHelper.saveTask()
                        self.performSegue(withIdentifier: "save", sender: UIButton())

                    })
                    alertController.addAction(cancel)
                    alertController.addAction(submitAction)
                    
                    
                    present(alertController, animated: true, completion: nil)
                    return
                }
                
                CoreDataHelper.saveTask()
                print("Task saved")
                self.performSegue(withIdentifier: "save", sender: UIButton())

                
                
            }
            else{
                let alertController = UIAlertController(title: "Please enter a valid integer", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            
            
            
        }
        
            func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "save"{
                    let weeklyCalender = segue.destination as! WeeklyCalendarViewController
                    weeklyCalender.tableView.reloadData() 
                }
        }
        //        if let identifier = segue.identifier {
                
        //            if identifier == "cancel" {
        //            } else if identifier == "save" {
        //                print("Save button tapped")
        //                let time = timePicker.text!
        //                print("checking input")
        //                if (time != "" && (textview.text != "" && textview.text != "Enter Text Here" && textview.text != "Placeholder")){
        //                    print("nil")
        //                    let task = self.task ?? CoreDataHelper.newTask()
        //
        //                    task.title = taskTitle.text!
        //                    task.endDate = selectedDate as NSDate!
        //                    print(task.endDate!)
        //                    let endDate = task.endDate as Date!
        //                    task.priority = PriorityPicker.text ?? ""
        //                    task.timeNeeded = Int32(timePicker.text!)!
        //                    task.taskDescription = textview.text ?? ""
        //                    task.timePerDay = Int32(endDate!.days(from: Date()))
        //                    print(endDate!.days(from: Date()))
        //                    CoreDataHelper.saveTask()
        //                    let weeklyCalendarViewController = segue.destination as! WeeklyCalendarViewController
        //                    weeklyCalendarViewController.tasks.append(task)
        //
        //                }
        //
        //
        //
        
        //                for _ in 0...7{
        
        
    }
    //}
    
    //}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 9 // Bool
    }
    
   
   
}




