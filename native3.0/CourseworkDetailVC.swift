//  CourseworkDetailVC
//  Native3.0
//
//  Created by  Mark O Grady on 05/05/2016.
//  Copyright © 2016  Mark O Grady All rights reserved.
//



import Foundation
import UIKit

class CourseworkDetailVC: UIViewController {
    var btn:UIBarButtonItem!
    var startDate:NSDate!
    var dueDate:NSDate!
    var reminder:NSDate!
    @IBOutlet weak var reminderLabel: UIButton!
    
    @IBOutlet weak var startDateLabel: UIButton!
    @IBOutlet weak var dueDateLabel: UIButton!
    @IBOutlet weak var moduleNameLbl: UITextField!
    @IBOutlet weak var levelDetailLbl: UITextField!
    @IBOutlet weak var courseworkDetailLbl: UITextField!
    var coursework: Coursework!
    
        @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {

         btn = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action:"editCourseworkDetails")
        self.navigationItem.rightBarButtonItem = btn
    

        
//        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let x = coursework.level {
            self.levelDetailLbl.text = "\(x)"
        } else {
            self.levelDetailLbl.text = ""
        }
        self.navigationItem.title = self.coursework.courseworkName
        self.courseworkDetailLbl.text = coursework.courseworkName
//        self.levelDetailLbl.text = "\(coursework.level!)"
        self.moduleNameLbl.text = coursework.moduleName
        
      
       
        if (coursework.dueDate != nil) {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            let dd = coursework.dueDate
            let dateString = formatter.stringFromDate(dd!)
            self.dueDateLabel.setTitle(dateString,forState: UIControlState.Normal)
            self.dueDate = coursework.dueDate
        } else {
            self.dueDateLabel.setTitle("No date set",forState: UIControlState.Normal)
        }
        
        if (coursework.startDate != nil) {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            let sd = coursework.startDate
            let dateString = formatter.stringFromDate(sd!)
            self.startDateLabel.setTitle(dateString,forState: UIControlState.Normal)
            self.startDate = coursework.startDate
        } else {
            self.startDateLabel.setTitle("No date set",forState: UIControlState.Normal)
        }
        
        if (coursework.reminder != nil) {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            let rm = coursework.reminder
            let dateString = formatter.stringFromDate(rm!)
            self.reminderLabel.setTitle(dateString,forState: UIControlState.Normal)
            self.reminder = coursework.reminder
        } else {
            self.reminderLabel.setTitle("No date set",forState: UIControlState.Normal)
        }
        notesTextView!.layer.borderWidth = 1
        notesTextView!.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.notesTextView.text = self.coursework.notes

        super.viewDidLoad()
        
    }
    
    func editCourseworkDetails() {
        if(btn.title == "Edit") {
            btn.title = "Done"
           reminderLabel.enabled = true
            notesTextView.editable = true
            notesTextView.backgroundColor = UIColor.whiteColor()

            startDateLabel.enabled = true
            dueDateLabel.enabled = true
            moduleNameLbl.enabled = true
            levelDetailLbl.enabled = true
            courseworkDetailLbl.enabled = true
            
        } else {
            btn.title = "Edit"
            reminderLabel.enabled = false
            startDateLabel.enabled = false
            dueDateLabel.enabled = false
            moduleNameLbl.enabled = false
            levelDetailLbl.enabled = false
            courseworkDetailLbl.enabled = false
            notesTextView.editable = false
            notesTextView.backgroundColor = hexStringToUIColor("#F2F2F2")
            
            coursework.courseworkName = self.courseworkDetailLbl.text
            coursework.moduleName = self.moduleNameLbl.text
            coursework.level = Int(self.levelDetailLbl.text!)
            if(self.startDateLabel.titleLabel!.text != "No date set") {
                coursework.startDate = startDate
            }
            if(self.dueDateLabel.titleLabel!.text != "No date set") {
                coursework.dueDate = dueDate
            }
            if(self.reminderLabel.titleLabel!.text != "No date set") {
                coursework.reminder = reminder
            }
            
            coursework.notes = self.notesTextView.text
//            coursework.dueDate = self.courseworkDetailLbl.text
//            coursework.courseworkName = self.courseworkDetailLbl.text
//            coursework.courseworkName = self.courseworkDetailLbl.text
//            coursework.courseworkName = self.courseworkDetailLbl.text
//            coursework.courseworkName = self.courseworkDetailLbl.text
        }
    }
    @IBAction func addStartDate(sender: UIButton) {
        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            
            
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            self.startDateLabel.setTitle("\(dateString)", forState: .Normal)
            self.startDate = date
           
        }
        
    }

    @IBAction func addDueDate(sender: UIButton) {
        DatePickerDialog().show("Due Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            
            
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            self.dueDateLabel.setTitle("\(dateString)", forState: .Normal)
            self.dueDate = date
            
        }

    }
    @IBAction func addReminder(sender: UIButton) {
        DatePickerDialog().show("Reminder", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            
            
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            self.reminderLabel.setTitle("\(dateString)", forState: .Normal)
            self.reminder = date
           
        }

    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}