//
//  DateHelper.swift
//  TheRealFindMe
//
//  Created by Willie Jiang on 7/18/17.
//  Copyright © 2017 Willie Jiang. All rights reserved.
//

import Foundation
import UIKit
extension Date{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
}


extension String{
    func isStringAnInt(string: String) -> Bool {
        return Int(string) == nil
    }

}
extension UIButton {
    
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

class Foo: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
    }
}
