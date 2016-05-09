//
//  AddCourseworkTableViewController.swift
//  Native3.0
//
//  Created by  Mark O Grady on 05/05/2016.
//  Copyright © 2016 Mark O Grady. All rights reserved.
//

import UIKit
import CoreData
import EventKit
class AddCourseworkTableViewController: UITableViewController {
    
    
    var currentText = ""
    var dueDate:NSDate!
    var startDate:NSDate!
    var reminderDate:NSDate!
    @IBOutlet weak var moduleLbl: UITextField!
    @IBOutlet weak var levelTxt: UITextField!
    @IBOutlet weak var addCourseworkNameTxt: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var courseworkName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
   
    @IBAction func addReminder(sender: UIButton) {
        
        
        
        DatePickerDialog().show("Reminder", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            
            
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            self.reminderButton.setTitle("\(dateString)", forState: .Normal)
            self.reminderDate = date
            
            
            
            let store:EKEventStore = EKEventStore()
            store.requestAccessToEntityType(EKEntityType.Event) { (granted, error) -> Void in
                
                if let e = error {
                    print("Error \(e.localizedDescription)")
                }
                
                if granted {
                    print("Calendar access granted")
                    
                    let date : NSDate = NSDate()
                    let event:EKEvent = EKEvent(eventStore: store)
                    print("Reminder for \(date)")
                    if (self.addCourseworkNameTxt.text! != "Add coursework Name" ) {
                        event.title = self.addCourseworkNameTxt.text!
                    }
                    
                    event.startDate =  self.reminderDate
                    event.endDate =  self.reminderDate
                    event.allDay = false
                    event.calendar = store.defaultCalendarForNewEvents
                do {
                        
                        try store.saveEvent(event, span: EKSpan.ThisEvent, commit: true)
                        
                    } catch {
                        
                        //let err:NSError?
                        print(error)
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func startDatePickerTapped(sender: UIButton) {
        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            
            
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            self.startDateButton.setTitle("\(dateString)", forState: .Normal)
            self.startDate = date
            
        }
        
    }
    @IBAction func dueDatePickerTapped(sender: UIButton) {
        DatePickerDialog().show("Due Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            
            
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            self.dueDateButton.setTitle("\(dateString)", forState: .Normal)
            self.dueDate = date
            
        }
        
    }
   
    @IBAction func textFinishEdit(sender: UITextField) {
        if sender.text!.isEmpty {
            sender.text = currentText
            sender.textColor = UIColor.lightGrayColor()
        }

    }
    
    @IBAction func textBeginEdit(sender: UITextField) {
        if sender.textColor != UIColor.blackColor() {
                        print("not black")
                        currentText = sender.text!
                    }
            
            if sender.textColor == UIColor.lightGrayColor() {
                print("grey")
                sender.text = nil
                sender.textColor = UIColor.blackColor()
                
            }

    }
    @IBAction func textDidBeginEditing(sender: UITextField) {

        if sender.textColor == UIColor.lightGrayColor() {
                print("grey")
            sender.text = nil
            sender.textColor = UIColor.blackColor()
            
        }
    }
    @IBAction func textDidFinishingEditing(sender: UITextField) {
        if sender.text!.isEmpty {
            sender.text = currentText
            sender.textColor = UIColor.lightGrayColor()
        }
    }
    override func viewDidLoad() {
        
        notesTextView!.layer.borderWidth = 1
        notesTextView!.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        self.notesTextView.layer.cornerRadius = 8;
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext

    }
    
    override func viewWillDisappear(animated: Bool) {
        if (self.addCourseworkNameTxt.text! == "Add coursework Name" ) {
            return
        }
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Coursework", inManagedObjectContext: managedObjectContext!) as! Coursework
        
        newManagedObject.courseworkName = self.addCourseworkNameTxt.text
        if(self.moduleLbl.text != "Add Module Name") {
            newManagedObject.moduleName = self.moduleLbl.text
        } else {
            newManagedObject.moduleName = ""
        }
        if(self.levelTxt.text != "Add Module Level") {
            newManagedObject.level = Int(self.levelTxt.text!)
        } else {
            newManagedObject.level = 0
        }
     
        newManagedObject.dueDate = dueDate
        newManagedObject.startDate = startDate
        
        newManagedObject.reminder = reminderDate
        newManagedObject.notes = self.notesTextView.text
        do {
            try managedObjectContext!.save()
        } catch {
            abort()
        }
        
    }
    
}
