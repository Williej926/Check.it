//
//  AddTaskViewController.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/18/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: UITableViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var deadlinePicker: UITextField!
    @IBOutlet weak var PriorityPicker: UITextField!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var timePicker: UITextField!
    @IBOutlet weak var textview: UITextView!
    let priorityOptions = ["Low", "Neutral", "High", "Urgent"]
    let array = ["taskname","taskdescription","deadline","priority","estimated"]
    var selectedDate = Date()
    
    
    
    

    
    override func viewDidLoad() {
        let pickerView = UIPickerView()
        let hourPickerView = UIPickerView()
        pickerView.tag = 1
        hourPickerView.tag = 2
        
        pickerView.delegate = self
        
        PriorityPicker.inputView = pickerView
        let datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(self.onDatePickerValueChanged), for: .valueChanged)
        deadlinePicker.inputView = datePicker
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        textview.delegate = self;
        
        
        view.addGestureRecognizer(tap)
        textview.text = "Enter Text Here"
        textview.textColor = UIColor.lightGray
        
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
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
        selectedDate = calendar.date(from:components)!
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell?.contentView.backgroundColor = UIColor.white
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Cancel button tapped")
            } else if identifier == "save" {
                print("Save button tapped")
                
                let task = Task()
                task.title = taskTitle.text!
                task.endDate = selectedDate
                task.priority = PriorityPicker.text ?? ""
                let weeklyCalendarViewController = segue.destination as! WeeklyCalendarViewController
                weeklyCalendarViewController.tasks.append(task)
                
                //                for _ in 0...7{
                
            }
        }
    }
    @IBAction func checkInput(_ sender: Any) {
        let time = timePicker.text!
        print("checking input")
        if time == "" {
            print("nil")
        }
        else{
            let alertController = UIAlertController(title: "no time selected", message: "please select a time", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            print("true")
            return
            
        }
    
    }
}



