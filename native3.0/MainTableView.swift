//  MainTableView.swift
//  Native3.0
//
//  Created by  Mark O Grady on 05/05/2016.
//  Copyright © 2016  Mark O Grady All rights reserved.
//


import UIKit
import CoreData

class MainTableView: UITableViewController {
    var helper:Helper!
    var courseworks: [Coursework]!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
       helper = Helper()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        fetchCourseworks()
        self.tableView.reloadData()
        super.viewDidLoad()
        self.navigationItem.title = "Done"
    }
    
    /**
     * This function is responsible for obtaining all courseworks from the DB
     * and placing them into an array
     **/
    func fetchCourseworks(){
        let courseworkFetchRequest = NSFetchRequest(entityName: "Coursework")
        do {
            courseworks = try managedObjectContext!.executeFetchRequest(courseworkFetchRequest) as! [Coursework]
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCoursework" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.courseworks[indexPath.row]
                let destinationVC = (segue.destinationViewController as UIViewController) as! CourseworkDetailVC
                destinationVC.coursework = object
                navigationItem.title = "Courseworks"
            }
        } else {
            navigationItem.title = "Done"

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchCourseworks()
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courseworks.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var lbl = ""
        let cell = tableView.dequeueReusableCellWithIdentifier("CWDisplayTableViewCell", forIndexPath: indexPath) as! CWDisplayTableViewCell
        let object = self.courseworks[indexPath.row] as Coursework
        if(object.dueDate != nil) {
            cell.logoLbl.layer.borderColor = helper.hexStringToUIColor("#073FA8").CGColor
            cell.logoLbl.layer.backgroundColor = helper.hexStringToUIColor("#1178BC").CGColor
            lbl = getDueDateForLogo(object)
            cell.logoLbl.text = lbl
            cell.logoLbl.font = UIFont(name: "system", size:55)
           
        } else {
            lbl = getLabelOutput(object)
             cell.logoLbl.layer.backgroundColor = helper.hexStringToUIColor("#EDEDED").CGColor
            cell.logoLbl.layer.borderColor = helper.hexStringToUIColor("#D1D1D1").CGColor
        }
        self.configureCell(cell, withObject: object)
        cell.logoLbl.text = lbl
        cell.courseworkNameLbl.text = object.courseworkName!.capitalizedString
        cell.moduleNameLbl.text = "Module: " + object.moduleName!.capitalizedString
        let val = Int(object.level!) + 4
        cell.levelLbl.text = "Level: \(val)"
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
                 managedObjectContext!.deleteObject(courseworks[indexPath.row] as NSManagedObject)
                 /**
                  * This section of the function searches for any tasks created for
                  * the deleted coursework. It will then check for any 
                  * notifications that
                  * have been created for the given coursework and delete them.
                  * It will then delete the tasks assigned to the coursework.
                  **/
                 let newManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                 let fetchRequest = NSFetchRequest(entityName: "Task")
                 if let fetchResults = try!newManagedObjectContext.executeFetchRequest(fetchRequest) as? [Task] {
                    for (var i=0; i < fetchResults.count; i++) {
                        if fetchResults[i].courseworkName == courseworks[indexPath.row].courseworkName {
                            
                            if let notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications {
                                
                                // 3. For each notification in the array ...
                                for notif in notifyArray as [UILocalNotification] {
                                    // ... try to cast the notification to the dictionary object
                                    if let info = notif.userInfo as? [String: String] {
                                        
                                        // 4. If the dictionary object ID is equal to the string you passed in ...
                                        if info["TaskID"] == fetchResults[i].taskName {
                                            print("Notification located and deleted")
                                            
                                            // ... cancel the current notification
                                            UIApplication.sharedApplication().cancelLocalNotification(notif)
                                        }
                                    }
                                }
                            }
                            //delete the task assigned to deleted coursework.
                            newManagedObjectContext.deleteObject(fetchResults[i])
                            
                        }
                    }
                    try!newManagedObjectContext.save()
                 }

            courseworks.removeAtIndex(indexPath.row)
            do {
                try  managedObjectContext!.save()
                           } catch {
                abort()
            }
             self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
            
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, withObject: anObject as! Coursework)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
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
    func getLabelOutput(cw:Coursework) -> String {
        let name = cw.courseworkName! as String
        let charAtIndex = getFirstCharacter(name)
        let upper = charAtIndex.uppercaseString
        
        return upper
    }
    
    /**
     * This function is responsible for returning the date for 
     * the table view label
     **/
    func getDueDateForLogo(cw:Coursework) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        let dateString = formatter.stringFromDate(cw.dueDate!)
        var strArr = dateString.componentsSeparatedByString(",")
        strArr = strArr[0].componentsSeparatedByString(" ")
        let month = String(strArr[0].characters.prefix(3))// get first 3 chars
       
        return month + "\n" + strArr[1]
    }

    func configureCell(cell: UITableViewCell, withObject object: Coursework) {
 
    }
    
}
