//  CourseworkDetailVC
//  Native3.0
//
//  Created by  Mark O Grady on 05/05/2016.
//  Copyright © 2016  Mark O Grady All rights reserved.
//



import Foundation
import UIKit
import CoreData
import EventKit

class CourseworkDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var progress: UIProgressView!
    var btn:UIBarButtonItem!
    var startDate:NSDate!
    var dueDate:NSDate!
    var reminder:NSDate!
    var tasks: [Task]!
    var helper:Helper!
    var countVal:Int!
    var countFloat:Float!
    var currentCoursework:String!
    var dueDateOnLoad:String!
    var reminderStateOnLoad:Int!
    var coursework: Coursework!
    var task: Task!
    @IBOutlet weak var reminderLabel: UIButton!
    @IBOutlet weak var reminderSeg: UISegmentedControl!
    @IBOutlet weak var levelSegment: UISegmentedControl!
    @IBOutlet weak var deleteCourseworkBtn: UIButton!
    @IBOutlet weak var percentageValueLbl: UILabel!
    @IBOutlet weak var weightTxt: UITextField!
    @IBOutlet weak var markAwardedTxt: UITextField!
    @IBOutlet weak var startDateLabel: UIButton!
    @IBOutlet weak var dueDateLabel: UIButton!
    @IBOutlet weak var moduleNameLbl: UITextField!
    @IBOutlet weak var courseworkDetailLbl: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        reminderStateOnLoad = reminderSeg.selectedSegmentIndex
        if(dueDateLabel.titleLabel!.text != "Date not set") {
            dueDateOnLoad = dueDateLabel.titleLabel!.text 
        }
        progress.setProgress(0, animated: true)
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        progress.transform = CGAffineTransformMakeScale(1, 3)

        helper = Helper()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        self.notesTextView.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
        
         btn = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action:"editCourseworkDetails")
        self.navigationItem.rightBarButtonItem = btn
    
        self.levelSegment.layer.cornerRadius = 15.0
        self.levelSegment.layer.borderColor = helper.hexStringToUIColor("#007AFF").CGColor
        self.levelSegment.layer.borderWidth = 1.0;
        self.levelSegment.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.levelSegment.layer.masksToBounds = true

        self.reminderSeg.layer.cornerRadius = 15.0;
        self.reminderSeg.layer.borderColor = helper.hexStringToUIColor("#007AFF").CGColor
        self.reminderSeg.layer.borderWidth = 1.0;
        self.reminderSeg.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.reminderSeg.layer.masksToBounds = true
        self.levelSegment.selectedSegmentIndex = Int(coursework.level!)
        self.navigationItem.title = self.coursework.courseworkName
        self.currentCoursework = self.coursework.courseworkName
        self.courseworkDetailLbl.text = coursework.courseworkName
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
        weightTxt.text = "\(coursework.weight!)"
        if(coursework.markAwarded == nil) {
            markAwardedTxt.text = "0"
        } else {
            markAwardedTxt.text = "\(coursework.markAwarded!)"
        }
        notesTextView!.layer.borderWidth = 1
        let c = helper.hexStringToUIColor("#D1D1D1")
        notesTextView!.layer.borderColor = c.CGColor
        notesTextView!.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
        self.reminderSeg.selectedSegmentIndex = Int(coursework.reminder!)
        self.notesTextView.text = self.coursework.notes
        self.notesTextView.layer.cornerRadius = 8;
        self.levelSegment.selectedSegmentIndex = Int(coursework.level!)
        fetchTasks()
        notesTextView.font = .systemFontOfSize(18)
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchTasks()
        self.taskTableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(dueDateOnLoad != dueDateLabel.titleLabel?.text && reminderSeg.selectedSegmentIndex == 1) {
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
                    if (self.courseworkDetailLbl.text! != "Add coursework Name" ) {
                        event.title = self.courseworkDetailLbl.text!
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

        }
    }
 
    /**
     * This function is responsible for returning all tasks from the
     * DB. It will then assign them to an array
     **/
    func fetchTasks() {
        var total = 0
        let taskFetchRequest = NSFetchRequest(entityName: "Task")
        do {
            let predicate = NSPredicate(format: "courseworkName == %@", currentCoursework)
            taskFetchRequest.predicate = predicate
            tasks = try managedObjectContext!.executeFetchRequest(taskFetchRequest) as! [Task]
            for order in tasks {
                let fQ = order.valueForKey("completedAmount") as! Int
                total += fQ
            }
            if(total != 0) {
                countFloat = Float(total/tasks.count)
            } else {
                countFloat = 0
            }
        } catch let error as NSError {
            print("Error: \(error)")
        }
        if(total != 0) {
            progress.setProgress(countFloat/100, animated: true)
            percentageValueLbl.text = "\(Int(countFloat))% Complete:"
            percentageValueLbl.textColor = helper.hexStringToUIColor("#000000")
            percentageValueLbl.font = UIFont.systemFontOfSize(16.0)
        } else {
            progress.setProgress(0, animated: true)
            percentageValueLbl.text = "0% Complete: "
        }
        if(Int(countFloat!) == 100) {
         
            progress.setProgress(100, animated: true)
            percentageValueLbl.text = "\(Int(countFloat))% Complete:"
            percentageValueLbl.textColor = helper.hexStringToUIColor("#34862D")
            percentageValueLbl.font = UIFont.boldSystemFontOfSize(16.0)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTask" {
                let destinationVC = (segue.destinationViewController as UIViewController) as! AddTaskTableVC
                destinationVC.courseworkName = self.currentCoursework
              navigationItem.title = "Done"
        }
        
        if segue.identifier == "showTaskDetail" {
            if let indexPath = self.taskTableView.indexPathForSelectedRow {
                let object = self.tasks[indexPath.row]
                let destinationVC = (segue.destinationViewController as UIViewController) as! TaskDetailVC
                destinationVC.currentCoursework = self.currentCoursework

                destinationVC.task = object
                 navigationItem.title = self.currentCoursework
               
            }
        }
    }
    
    /**
     * This function is responsible for configuring the view when the edit 
     * button is clicked.
     **/
    func editCourseworkDetails() {
       
        if(btn.title == "Edit") {
            btn.title = "Done"
            notesTextView.editable = true
            notesTextView.backgroundColor = UIColor.whiteColor()

            startDateLabel.userInteractionEnabled = true
            dueDateLabel.userInteractionEnabled = true
            moduleNameLbl.enabled = true
            courseworkDetailLbl.enabled = true
            weightTxt.enabled = true
            markAwardedTxt.enabled = true
            levelSegment.userInteractionEnabled = true
            reminderSeg.userInteractionEnabled = true
        } else {
            btn.title = "Edit"
            startDateLabel.userInteractionEnabled = false
            dueDateLabel.userInteractionEnabled = false
            moduleNameLbl.enabled = false
            courseworkDetailLbl.enabled = false
            weightTxt.enabled = false
            markAwardedTxt.enabled = false
            notesTextView.editable = false
            levelSegment.userInteractionEnabled = false
            reminderSeg.userInteractionEnabled = true
            notesTextView.backgroundColor = helper.hexStringToUIColor("#FAFAFA")
            
            coursework.reminder = self.reminderSeg.selectedSegmentIndex
            coursework.courseworkName = self.courseworkDetailLbl.text
            coursework.moduleName = self.moduleNameLbl.text
            coursework.level = Int(self.levelSegment.selectedSegmentIndex)
            if(self.startDateLabel.titleLabel!.text != "No date set") {
                coursework.startDate = startDate
            }
            
            if(self.dueDateLabel.titleLabel!.text != "No date set") {
                coursework.dueDate = dueDate

            }
            coursework.weight = Int(weightTxt.text!)
            coursework.markAwarded = Double(markAwardedTxt.text!)
            coursework.notes = self.notesTextView.text

            do{
                try managedObjectContext!.save()
            } catch{
                abort()
            }

        }
    }
    
    /**
     * This function is responsible for displaying the date picker when
     * the start date button is clicked
     **/
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
    
    /**
     * This function is responsible setting up the reminder when the segment is
     * set to "Yes"
     **/
    @IBAction func reminderSegmentChanged(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 1) {
            addReminder()
        }
    }
    
    /**
     * This function is responsible for displaying the date picker when
     * the due date button is clicked
     **/
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
    
    /**
     * This function is responsible for displaying the alert if the
     * reminder is set to "Yes" but the coursework name or due date have not been
     * provided
     **/
    func addReminder() {
        if(self.dueDate == nil) {
            print("Missing coursework details")
            let alert = UIAlertController(title: "No due date", message: "You need to set the due date to set a reminder", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.reminderSeg.selectedSegmentIndex = 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countVal = self.tasks.count
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskDisplayTableViewCell
     
        let object = self.tasks[indexPath.row] as Task
        var lbl = ""
        if(object.dueDate != nil) {
            cell.logoLbl.layer.backgroundColor = helper.hexStringToUIColor("#1178BC").CGColor
            lbl = getDueDateForLogo(object)
             cell.logoLbl.font = .systemFontOfSize(15)
        } else {
            
            lbl = getLabelOutput(object)
            cell.logoLbl.layer.backgroundColor = helper.hexStringToUIColor("#EDEDED").CGColor
             cell.logoLbl.font = .systemFontOfSize(28)
            
        }
        cell.logoLbl.text = lbl
        cell.taskNameLbl.text = object.taskName!.capitalizedString
        cell.completedLbl.text = "Completed: \(object.completedAmount!)%"
        if object.dueDate != nil {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(object.dueDate!)
            cell.taskDueDateLbl.text = "Due Date: \(dateString)"
        } else {
            cell.taskDueDateLbl.text = "Due Date: Not Set"
        }
        self.configureCell(cell, withObject: object)
        return cell
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            managedObjectContext!.deleteObject(tasks[indexPath.row] as NSManagedObject)
            tasks.removeAtIndex(indexPath.row)
            fetchTasks()
            do {
                try  managedObjectContext!.save()
                
            } catch {
                abort()
            }
            self.taskTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
            
        }
    }
    
    func configureCell(cell: UITableViewCell, withObject object: Task) {
    }
    
    /**
     * This function is responsible for returning the dueDate string 
     * when the table is displayed
     **/
    func getDueDateForLogo(cw:Task) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        let dateString = formatter.stringFromDate(cw.dueDate!)
        var strArr = dateString.componentsSeparatedByString(",")
        strArr = strArr[0].componentsSeparatedByString(" ")
         let month = String(strArr[0].characters.prefix(3))// get first 3 chars
        return month + " " + strArr[1]
    }
    
    /**
     * This function is responsible for returning the first
     * character from the given string
     **/
    func getFirstCharacter(str: String) -> String {
        return  String(str[str.startIndex.advancedBy(0)])
    }
    
    /**
     * This function is responsible for returning a string
     * which contains a single uppercasae character
     **/
    func getLabelOutput(cw:Task) -> String {
        let name = cw.taskName! as String
        let charAtIndex = getFirstCharacter(name)
        let upper = charAtIndex.uppercaseString
        
        return upper
    }
}