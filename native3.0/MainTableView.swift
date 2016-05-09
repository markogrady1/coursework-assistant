//  MainTableView.swift
//  Native3.0
//
//  Created by  Mark O Grady on 05/05/2016.
//  Copyright © 2016  Mark O Grady All rights reserved.
//


import UIKit
import CoreData

class MainTableView: UITableViewController {
    
    var courseworks: [Coursework]!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
       
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        fetchCourseworks()
        self.tableView.reloadData()
        super.viewDidLoad()
        let appDeleg: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDeleg.managedObjectContext
        let fetchreq = NSFetchRequest(entityName: "Numbers")
        
        //Would I be adding the sort descriptor here?
        let sortDescriptor = NSSortDescriptor(key: "numbersAttribute", ascending: true)
//        fetchreq.sortDescriptors = [sortDescriptors]
    }
    
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
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchCourseworks()
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courseworks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = self.courseworks[indexPath.row] as Coursework
        self.configureCell(cell, withObject: object)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.managedObjectContext
            context!.deleteObject(self.courseworks[indexPath.row] as Coursework)
            
            do {
                try context!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
            self.tableView.reloadData()
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
    
    func configureCell(cell: UITableViewCell, withObject object: Coursework) {
        cell.textLabel!.text = object.courseworkName
        
//        cell.detailTextLabel!.text = "Module: \(object.moduleName!)"
        
        
        let text: NSString = "Module: \(object.moduleName!)"
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text as String)
        attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(11)], range: NSRange(location: 0, length: 7))
        
        cell.detailTextLabel?.attributedText = attributedText
    }
    
}
