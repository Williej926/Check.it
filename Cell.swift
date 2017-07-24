//
//  Cell.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/18/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//


import Foundation
import UIKit
class Cell: UITableViewCell{
    
    @IBOutlet weak var taskTime: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var taskName: UILabel!
    var feasibleTasks = [Task]()
    var actualTasks = [Task]()
}
