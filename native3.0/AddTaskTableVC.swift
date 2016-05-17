//
//  AddTaskTableVC.swift
//  native3.0
//
//  Created by Mark O'Grady on 09/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import UIKit
import CoreData
import EventKit
class AddTaskTableVC: UITableViewController {
    
 
  
    var btn: UIBarButtonItem!
    var helper:Helper!
    var courseworkName:String!
    var startDate:NSDate!
    var dueDate: NSDate!
    var reminder:NSDate!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    @IBOutlet weak var taskNameTxt: UITextField!
    @IBOutlet weak var reminderSeg: UISegmentedControl!
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var completedSlider: UISlider!
    @IBOutlet weak var reminderBtn: UIButton!
    @IBOutlet weak var dueDateBtn: UIButton!
    
    override func viewDidLoad() {
        notesTextView.font = .systemFontOfSize(18)
        btn = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action:"clearForm")
        self.navigationItem.rightBarButtonItem = btn
        
        self.navigationItem.title = "Add Task"
        super.viewDidLoad()
        helper = Helper()
        notesTextView!.layer.borderWidth = 1
        let c = helper.hexStringToUIColor("#D1D1D1")
        notesTextView!.layer.borderColor = c.CGColor
        notesTextView!.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
        self.notesTextView.layer.cornerRadius = 8
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        self.reminderSeg.layer.cornerRadius = 15.0
        self.reminderSeg.layer.borderColor = helper.hexStringToUIColor("#007AFF").CGColor
        self.reminderSeg.layer.borderWidth = 1.0
        self.reminderSeg.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.reminderSeg.layer.masksToBounds = true
    }
   
    func addReminder() {
        
        if(self.dueDate != nil && self.taskNameTxt.text != "") {
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
                    if (self.taskNameTxt.text! != "" ) {
                        event.title = self.taskNameTxt.text!
                    }
                    
                    event.startDate =  self.dueDate
                    event.endDate =  self.dueDate
                    event.allDay = false
                    event.calendar = store.defaultCalendarForNewEvents
                    do {
                        
                        try store.saveEvent(event, span: EKSpan.ThisEvent, commit: true)
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }else {
            print("Missing coursework details")
            let alert = UIAlertController(title: "No due date", message: "You need to set the due date to and task name to set a reminder", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.reminderSeg.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func startDateButtonTapped(sender: UIButton) {
        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            let dateString = formatter.stringFromDate(date)
            self.startDateBtn.setTitle("\(dateString)", forState: .Normal)
            self.startDate = date
        }
    }
    
    @IBAction func reminderSegChanged(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 1) {
            addReminder()
        }        
    }
    
    @IBAction func dueDateButtonTapped(sender: UIButton) {
        DatePickerDialog().show("Due Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            let dateString = formatter.stringFromDate(date)
            self.dueDateBtn.setTitle("\(dateString)", forState: .Normal)
            self.dueDate = date
        }
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        let sliderVal = sender.value
        self.completedLbl.text = "Completed \(Int(sliderVal))%"
    }
    override func viewWillDisappear(animated: Bool) {
        if (self.taskNameTxt.text! == "" ) {
            return
        }
      
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: managedObjectContext!) as! Task
        newManagedObject.courseworkName = courseworkName
        newManagedObject.taskName = self.taskNameTxt.text
        if(startDate != nil && dueDate != nil) {
            let days = daysBetweenDate(startDate, endDate: dueDate)
            newManagedObject.lengthOfTime = days
        }
        
        newManagedObject.completedAmount = Int(self.completedSlider.value)
        newManagedObject.dueDate = dueDate
        newManagedObject.startDate = startDate
        newManagedObject.reminder = reminderSeg.selectedSegmentIndex
        if(self.notesTextView.text != "") {
             newManagedObject.notes = self.notesTextView.text

        }
               do {
            try managedObjectContext!.save()
        } catch {
            abort()
        }
        if(newManagedObject.dueDate != nil) {
            print("Due date notification set from addTaskTableVC")
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            let notification = UILocalNotification()
            notification.fireDate = dueDate
            notification.alertBody = "The \(self.taskNameTxt.text!) task has not been completed on time."
            notification.alertAction = "Task Notification"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["TaskID": self.taskNameTxt.text!]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        return components.day
    }
    
    func secondsBetweenDate(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        return components.second
    }
    
    func clearForm() {
        self.taskNameTxt.text = ""
        self.completedSlider.value = 0
        self.startDateBtn.setTitle("Designate a start date", forState: .Normal)
        self.dueDateBtn.setTitle("Designate a due date", forState: .Normal)
        self.reminderSeg.selectedSegmentIndex = 0
        self.notesTextView.text = ""
    }
}