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
    @IBOutlet weak var reminderSeg: UISegmentedControl!
    var btn:UIBarButtonItem!
    var helper:Helper!
    var currentText = ""
    var dueDate:NSDate!
    var startDate:NSDate!
    var reminderDate:NSDate!
    @IBOutlet weak var moduleLbl: UITextField!
    @IBOutlet weak var levelSegements: UISegmentedControl!
    @IBOutlet weak var weightTxt: UITextField!
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
   
    override func viewDidLoad() {
          helper = Helper()
        super.viewDidLoad()
        self.navigationItem.title = "Add Coursework"
        self.levelSegements.layer.cornerRadius = 15.0;
        self.levelSegements.layer.borderColor = helper.hexStringToUIColor("#007AFF").CGColor
        self.levelSegements.layer.borderWidth = 1.0;
        self.levelSegements.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.levelSegements.layer.masksToBounds = true
        
        self.reminderSeg.layer.cornerRadius = 15.0;
        self.reminderSeg.layer.borderColor = helper.hexStringToUIColor("#007AFF").CGColor
        self.reminderSeg.layer.borderWidth = 1.0;
        self.reminderSeg.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.reminderSeg.layer.masksToBounds = true
        btn = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action:"clearForm")
        self.navigationItem.rightBarButtonItem = btn
        notesTextView!.layer.borderWidth = 1
        let c = helper.hexStringToUIColor("#D1D1D1")
        notesTextView!.layer.borderColor = c.CGColor
        notesTextView!.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
        self.notesTextView.layer.cornerRadius = 8;
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
    }

    @IBAction func levelSegementChanged(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 1) {
            print("true")
            addReminder()
        }
    }
    
    func addReminder() {
        if(dueDate != nil && self.addCourseworkNameTxt.text != "") {
            let store:EKEventStore = EKEventStore()
            store.requestAccessToEntityType(EKEntityType.Event) { (granted, error) -> Void in
                
                if let e = error {
                    print("Error \(e.localizedDescription)")
                }
                
                if granted {
                    print("Calendar access granted")
                    
                    let date : NSDate = NSDate()
                    let event:EKEvent = EKEvent(eventStore: store)
                    print("Reminder set for \(date)")
                    if (self.addCourseworkNameTxt.text! != "Add coursework Name" ) {
                        event.title = self.addCourseworkNameTxt.text!
                    }
                    
                    event.startDate =  self.dueDate
                    event.endDate =  self.dueDate
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
        } else {
            print("Missing coursework details")
            let alert = UIAlertController(title: "No due date", message: "You need to set both the due date and coursework name to set a reminder", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.reminderSeg.selectedSegmentIndex = 0
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
    
        override func viewWillDisappear(animated: Bool) {
        if (self.addCourseworkNameTxt.text! == "" ) {
            return
        }
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Coursework", inManagedObjectContext: managedObjectContext!) as! Coursework
        
        newManagedObject.courseworkName = self.addCourseworkNameTxt.text
        if(self.moduleLbl.text != "") {
            newManagedObject.moduleName = self.moduleLbl.text
        } else {
            newManagedObject.moduleName = ""
        }
        switch levelSegements.selectedSegmentIndex
        {
        case 0:
            newManagedObject.level = 0
        case 1:
            newManagedObject.level = 1
        case 2:
             newManagedObject.level = 2
        case 3:
             newManagedObject.level = 3
        default:
            break; 
        }
    
       
        if(self.weightTxt.text != "") {
            if(Int(self.weightTxt.text!) > 100) {
                self.weightTxt.text = "100"
            }
            
            if(Int(self.weightTxt.text!) < 0) {
                self.weightTxt.text = "0"
            }
            newManagedObject.weight = Int(self.weightTxt.text!)
        } else {
            newManagedObject.weight = 0
        }
        newManagedObject.dueDate = dueDate
        newManagedObject.startDate = startDate
        newManagedObject.reminder = self.reminderSeg.selectedSegmentIndex
        newManagedObject.notes = self.notesTextView.text
        do {
            try managedObjectContext!.save()
        } catch {
            abort()
        }
    }
    
    func clearForm() {
        self.moduleLbl.text = ""
        self.levelSegements.selectedSegmentIndex = 0
        self.weightTxt.text = ""
        self.addCourseworkNameTxt.text = ""
        self.notesTextView.text = ""
        self.startDateButton.setTitle("Designate a start date", forState: .Normal)
        self.dueDateButton.setTitle("Designate a due date", forState: .Normal)
        self.reminderSeg.selectedSegmentIndex = 0
    }
}
