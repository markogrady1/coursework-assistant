//
//  addCourseworkVC.swift
//  Native3.0
//
//  Created by  Mark O Grady on 05/05/2016.
//  Copyright © 2016  Mark O Grady All rights reserved.
//

import UIKit
import CoreData
import EventKit
class AddCourseworkVC: UIViewController {
    
    
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
//    @IBAction func datePickerTapped(sender: UIButton) {
//        DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
//            
//            
//            (date) -> Void in
//            let formatter = NSDateFormatter()
//            formatter.dateStyle = NSDateFormatterStyle.LongStyle
//            formatter.timeStyle = .MediumStyle
//            
//            let dateString = formatter.stringFromDate(date)
//            self.dateButton.setTitle("\(dateString)", forState: .Normal)
//            self.dueDate = date
//            print("\(date)")
//        }
//    }
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
                
                // 60 seconds before
//                let alarm:EKAlarm = EKAlarm(relativeOffset: -60)
//                event.alarms = [alarm]
                
                
                
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
//    func textViewDidBeginEditing(textView: UITextView) {
//        if textView.textColor == UIColor.lightGrayColor() {
//            textView.text = nil
//            textView.textColor = UIColor.blackColor()
//        }
//    }
    @IBAction func textDidBeginEditing(sender: UITextField) {
        if sender.textColor != UIColor.blackColor() {
             currentText = sender.text!
        }
       
        if sender.textColor == UIColor.lightGrayColor() {
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
        levelTxt.text = "Add Module Level"
        levelTxt.textColor = UIColor.lightGrayColor()
        
        moduleLbl.text = "Add Module Name"
        moduleLbl.textColor = UIColor.lightGrayColor()

//        addCourseworkNameTxt.text = "Add coursework Name"
        addCourseworkNameTxt.textColor = UIColor.lightGrayColor()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        let line1 = UIView(frame: CGRectMake(50,130,620,1.0))
        line1.layer.borderWidth = 1.0
        line1.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(line1)
        
        let line2 = UIView(frame: CGRectMake(50,180,620,1.0))
        line2.layer.borderWidth = 1.0
        line2.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(line2)
        
        let line3 = UIView(frame: CGRectMake(50,225,620,1.0))
        line3.layer.borderWidth = 1.0
        line3.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(line3)
        //
        let line4 = UIView(frame: CGRectMake(50,270,620,1.0))
        line4.layer.borderWidth = 1.0
        line4.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(line4)
        
        let line5 = UIView(frame: CGRectMake(50,320,620,1.0))
        line5.layer.borderWidth = 1.0
        line5.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(line5)
//
        let line6 = UIView(frame: CGRectMake(50,375,620,1.0))
        line6.layer.borderWidth = 1.0
        line6.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(line6)


//        super.viewDidLoad()
//        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
//    func datePickerChanged(datePicker:UIDatePicker) {
//        let dateFormatter = NSDateFormatter()
//        
//        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
//        
//        let strDate = dateFormatter.stringFromDate(datePicker.date)
//        dateLabel.text = strDate
//    }
//    @IBAction func buttonCalendar(sender: AnyObject) {
//        let eventStore = EKEventStore()
//        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
//        if(EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
//            eventStore.requestAccessToEntityType(.Event, completion: {
//                granted, error in
//            })
//        } else {
//            
//        }
//    
//    
//           }
    
//    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
//        let event = EKEvent(eventStore: eventStore)
//        event.title = title
//        event.startDate = startDate
//        event.endDate = endDate
//        event.calendar = eventStore.defaultCalendarForNewEvents
//        do {
//            try eventStore.saveEvent(event, span: .ThisEvent)
//        } catch {
//            print("bad event")
//        }
//    }
//    
    
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

//        newManagedObject.level = Int(self.levelTxt.text!)
//        newManagedObject.moduleName = self.moduleLbl.text
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
