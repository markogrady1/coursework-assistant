//
//  TaskDetailVC.swift
//  native3.0
//
//  Created by Mark O'Grady on 10/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreData
import EventKit

class TaskDetailVC: UITableViewController {
    var currentCoursework:String!
    var startNotGiven:Bool!
    var helper: Helper!
    var tasks: [Task]!
    var task: Task!
    var startDate:NSDate!
    var dueDate:NSDate!
    var loadingDueDate:NSDate!
    var reminder:NSDate!
    var btn:UIBarButtonItem!
    var days:Int!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    var dueDateOnLoad:String!
    var overProgress:UIView!
    var underProgress:UIView!
    var percentageState = 0;
    @IBOutlet weak var redStatusLbl: UILabel!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet weak var compSlider: UISlider!
    @IBOutlet weak var redLowerView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var taskNameTxt: UITextField!
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var dueDateBtn: UIButton!
    @IBOutlet weak var reminderBtn: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var reminderSeg: UISegmentedControl!
    @IBOutlet weak var sliderLbl: UILabel!
    @IBOutlet weak var lengthOfTimeTxt: UITextField!
    var percentageLabel:UILabel!
//    override func viewDidDisappear(animated: Bool) {
//        underProgress.removeFromSuperview()
//        overProgress.removeFromSuperview()
//        self.view.addSubview(underProgress)
//    }

    
    override func viewWillAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(1.8, target: self, selector: "update", userInfo: nil, repeats: false)
    }
    
    func update() {
        if(compSlider.value == 100.0) {
            self.overProgress.layer.borderColor = self.helper.hexStringToUIColor("44AA3A").CGColor
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        percentageLabel = UILabel(frame: CGRectMake(80, 80, 200, 21))
        percentageLabel.center = CGPointMake(75, 652)
        percentageLabel.textAlignment = NSTextAlignment.Center
        percentageLabel.text = "0%"
        self.view.addSubview(percentageLabel)

        /**
        * Add the CGRect underline for progressbar
        **/
        underProgress = UIView(frame: CGRectMake(150,650,600,7.0))
        overProgress = UIView(frame: CGRectMake(150,650,600,7.0))
        underProgress.layer.borderWidth = 6.0
        underProgress.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(underProgress)
        
       
        
        helper = Helper()
        self.navigationItem.title = self.task.taskName
        compSlider.transform = CGAffineTransformMakeScale(1, 1.2);
        self.notesTextView.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
        btn = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action:"editTaskDetails")
        self.navigationItem.rightBarButtonItem = btn
        notesTextView!.layer.borderWidth = 1
        let c = helper.hexStringToUIColor("#D1D1D1")
        notesTextView!.layer.borderColor = c.CGColor
        notesTextView!.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
        self.notesTextView.text = self.task.notes
        self.notesTextView.layer.cornerRadius = 8;

        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        self.taskNameTxt.text = task.taskName
        self.sliderLbl.text = "Completed \(task.completedAmount!)%"
        self.compSlider.value = Float(task.completedAmount!)
        if (task.dueDate != nil) {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            let dd = task.dueDate
            let dateString = formatter.stringFromDate(dd!)
            self.dueDateBtn.setTitle(dateString,forState: UIControlState.Normal)
            self.dueDate = task.dueDate
            self.loadingDueDate = dueDate
            self.dueDateOnLoad = dueDateBtn.titleLabel?.text
        } else {
            self.dueDateBtn.setTitle("No date set",forState: UIControlState.Normal)
        }
        
        if (task.startDate != nil) {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            let sd = task.startDate
            let dateString = formatter.stringFromDate(sd!)
            self.startDateBtn.setTitle(dateString,forState: UIControlState.Normal)
            self.startDate = task.startDate
        } else {
            self.startDateBtn.setTitle("No date set",forState: UIControlState.Normal)
        }
            self.reminderSeg.selectedSegmentIndex = Int(task.reminder!)

        if(task.startDate != nil && task.dueDate != nil) {
            
            let todaysDate:NSDate = NSDate()
            if startDate.compare(todaysDate) == NSComparisonResult.OrderedDescending {
                redStatusLbl.text = "Task has not started"
                redView.backgroundColor = helper.hexStringToUIColor("#00000")
                redLowerView.backgroundColor = helper.hexStringToUIColor("#00000")
                days = daysBetweenDate(startDate, endDate: dueDate )
            } else {
                days = daysBetweenDate(todaysDate, endDate: dueDate )
                let s = days == 1 ? "" : "s"
                days = days < 0 ? 0 : days
                redStatusLbl.text = "Task has started. DUE IN \(days) DAY\(s)"
                redView.backgroundColor = helper.hexStringToUIColor("#F64747")
                redLowerView.backgroundColor = helper.hexStringToUIColor("#F64747")
            }
            let s = days == 1 ? "" : "s"
            days = days < 0 ? 0 : days
          self.lengthOfTimeTxt.text = "\(days) day" + s
        } else {
            self.lengthOfTimeTxt.text = "0 days"
            redView.backgroundColor = helper.hexStringToUIColor("#00000")
            redLowerView.backgroundColor = helper.hexStringToUIColor("#00000")
            redStatusLbl.text = "No dates set"
        }
       
        self.notesTextView.text = task.notes
        if(task.completedAmount == 100) {
            redStatusLbl.text = "Task Complete"
            redView.backgroundColor = helper.hexStringToUIColor("#45AD3B")
            redLowerView.backgroundColor = helper.hexStringToUIColor("#45AD3B")
        }
        self.reminderSeg.layer.cornerRadius = 15.0;
        self.reminderSeg.layer.borderColor = helper.hexStringToUIColor("#007AFF").CGColor
        self.reminderSeg.layer.borderWidth = 1.0;
        self.reminderSeg.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.reminderSeg.layer.masksToBounds = true
        
        addProgressGraphic()
        

    }
    
    func addProgressGraphic() {
        
        let val = CGFloat(compSlider.value)
        overProgress = UIView(frame: CGRectMake(150,650,0,7.0))
        overProgress.layer.borderWidth = 6.0
        overProgress.layer.borderColor = helper.hexStringToUIColor("007AFF").CGColor
        self.view.addSubview(overProgress)
        UIView.animateWithDuration(2.0, animations: {
            self.overProgress.frame = CGRect(x: 150, y: 650, width: 0, height: 7.0)
            print("lsadjf")
            }, completion: { finished in
                UIView.animateWithDuration(2.0, animations: {
                    self.overProgress.frame = CGRect(x: 150, y: 650, width: val*6, height: 7.0)
                })
        })
        let interval = val <= 50 ? 0.1 : 0.01
        NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "addPercentageText", userInfo: nil, repeats: true)
        

    }
    func addPercentageText() {
        //        percentageState + percentageState + 1
        if(percentageState <= Int(compSlider.value)) {
            self.percentageLabel.text = "\(percentageState++)% Complete:"
        }
        
    }
    
    @IBAction func reminderSegChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            addReminder()
        }
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        let sliderVal = Int(sender.value)
        sliderLbl.text = "Completed \(sliderVal)%"
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

    func editTaskDetails() {
        if(btn.title == "Edit") {
            btn.title = "Done"
            taskNameTxt.enabled = true
            reminderSeg.userInteractionEnabled = true
            notesTextView.editable = true
            notesTextView.backgroundColor = UIColor.whiteColor()
            startDateBtn.userInteractionEnabled = true
            dueDateBtn.userInteractionEnabled = true
            compSlider.enabled = true
        } else {
            btn.title = "Edit"
            
            taskNameTxt.enabled = false
            reminderSeg.userInteractionEnabled = false
            notesTextView.editable = false
            startDateBtn.userInteractionEnabled = false
            dueDateBtn.userInteractionEnabled = false
            compSlider.enabled = false
            notesTextView.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
            //assign new values to DB
            task.courseworkName = currentCoursework
            task.taskName = taskNameTxt.text
            task.completedAmount = compSlider.value
            task.lengthOfTime = Int(lengthOfTimeTxt.text!)
            task.notes = notesTextView.text
            if(self.startDateBtn.titleLabel!.text != "No date set") {
                task.startDate = startDate
            }
            if(self.dueDateBtn.titleLabel!.text != "No date set") {
                task.dueDate = dueDate
            }
            task.reminder = reminderSeg.selectedSegmentIndex
            if(task.completedAmount == 100) {
                cancelNotification()
            } else {
                if(startDate != nil && dueDate != nil) {
                    let todaysDate:NSDate = NSDate()
                    if startDate.compare(todaysDate) == NSComparisonResult.OrderedDescending {
                        redStatusLbl.text = "Task has not started"
                        redView.backgroundColor = helper.hexStringToUIColor("#00000")
                        redLowerView.backgroundColor = helper.hexStringToUIColor("#00000")
                        days = daysBetweenDate(startDate, endDate: dueDate )
                    } else {
                        days = daysBetweenDate(todaysDate, endDate: dueDate )
                        days = daysBetweenDate(todaysDate, endDate: dueDate )
                        let s = days == 1 ? "" : "s"
                        days = days < 0 ? 0 : days
                        redStatusLbl.text = "Task has started. DUE IN \(days) DAY\(s)"
                        redView.backgroundColor = helper.hexStringToUIColor("#F54646")
                        redLowerView.backgroundColor = helper.hexStringToUIColor("#F54646")
                    }
                    task.lengthOfTime = days
                    let s = days == 1 ? "" : "s"
                    days = days < 0 ? 0 : days
                    self.lengthOfTimeTxt.text = "\(task.lengthOfTime!) day" + s
                } else {
                    redView.backgroundColor = helper.hexStringToUIColor("#00000")
                    redLowerView.backgroundColor = helper.hexStringToUIColor("#00000")
                    redStatusLbl.text = "No dates set"
                }

            }
                     
            if(task.completedAmount == 100) {
                cancelNotification()
                redStatusLbl.text = "Task Complete"
                redView.backgroundColor = helper.hexStringToUIColor("#45AD3B")
                redLowerView.backgroundColor = helper.hexStringToUIColor("#45AD3B")
            }
            
            do{
               try managedObjectContext!.save()
            } catch{
                abort()
            }
          
            if dueDateOnLoad != dueDateBtn.titleLabel?.text &&
                reminderSeg.selectedSegmentIndex == 1 &&
                compSlider.value != 100 {
                dueDateOnLoad = dueDateBtn.titleLabel?.text
                print("new notification condition")
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
                  checkForExistingNotification()
            } else {
                print("No new notifications")
            }
            NSTimer.scheduledTimerWithTimeInterval(1.8, target: self, selector: "update", userInfo: nil, repeats: false)

            percentageState = 0
            overProgress.removeFromSuperview()
            addProgressGraphic()
        }
        
        

    }

    func cancelNotification() {
        if let notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notif in notifyArray as [UILocalNotification] {
                if let info = notif.userInfo as? [String: String] {
                    if info["TaskID"] == task.taskName {
                        print("Notification located and deleted")
                        UIApplication.sharedApplication().cancelLocalNotification(notif)
                    }
                }
            }
        }

    }
    func checkForExistingNotification() {
        if let notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notif in notifyArray as [UILocalNotification] {
                if let info = notif.userInfo as? [String: String] {
                    if info["TaskID"] == task.taskName {
                        print("found previous id")
                        UIApplication.sharedApplication().cancelLocalNotification(notif)
                    }
                }
            }
        }
        
        print("due date notification set from TaskDetailVC")
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        let notification = UILocalNotification()
        notification.fireDate = dueDate//
        notification.alertBody = "The \(self.taskNameTxt.text!) task has not been completed on time."
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["TaskID": self.taskNameTxt.text!]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    @IBAction func addStartDate(sender: UIButton) {
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
    
    @IBAction func addDueDate(sender: UIButton) {
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
    
    func addReminder() {
        if(self.dueDate != nil) {
            
        }else {
            print("Missing coursework details")
            let alert = UIAlertController(title: "No due date", message: "You need to set the due date to set a reminder", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.reminderSeg.selectedSegmentIndex = 0
        }
    }
}
