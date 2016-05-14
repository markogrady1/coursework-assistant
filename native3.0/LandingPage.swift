//
//  LandingPage.swift
//  native3.0
//
//  Created by Mark O'Grady on 12/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LandingPage: UIViewController {
    @IBOutlet weak var viewCourseworkBtn: UIButton!
    var helper:Helper!
    var courseworks: [Coursework]!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    @IBOutlet weak var courseworkNumber: UILabel!
    @IBOutlet weak var cwBtnAmount: UIButton!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "courseworkListFromHome"{
            navigationItem.title = "Done"
        }
        if segue.identifier == "addCourseworkFromHome"{
            navigationItem.title = "Done"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        viewCourseworkBtn.setTitle("\nAdd Coursework\n", forState: .Normal)
        helper = Helper()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        

        cwBtnAmount.layer.cornerRadius = 5
        cwBtnAmount.layer.borderWidth = 2
        cwBtnAmount.layer.borderColor = UIColor.whiteColor().CGColor
        viewCourseworkBtn.layer.cornerRadius = 5
        viewCourseworkBtn.layer.borderWidth = 2
        viewCourseworkBtn.layer.borderColor = UIColor.whiteColor().CGColor
        let courseworkFetchRequest = NSFetchRequest(entityName: "Coursework")
        do {
            courseworks = try managedObjectContext!.executeFetchRequest(courseworkFetchRequest) as! [Coursework]
            let str = courseworks.count > 9 ? "" : " "
            cwBtnAmount.setTitle("\nCourseworks\r"+str+"         \(courseworks.count)\n", forState: .Normal)
            print("number of courseworks",courseworks.count)
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }

     override func viewDidLoad() {
        super.viewDidLoad()
        viewCourseworkBtn.setTitle("\nAdd Coursework\n", forState: .Normal)
        helper = Helper()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        cwBtnAmount.layer.cornerRadius = 5
        cwBtnAmount.layer.borderWidth = 2
        cwBtnAmount.layer.borderColor = UIColor.whiteColor().CGColor
        viewCourseworkBtn.layer.cornerRadius = 5
        viewCourseworkBtn.layer.borderWidth = 2
        viewCourseworkBtn.layer.borderColor = UIColor.whiteColor().CGColor
        let courseworkFetchRequest = NSFetchRequest(entityName: "Coursework")
        do {
            courseworks = try managedObjectContext!.executeFetchRequest(courseworkFetchRequest) as! [Coursework]
            let str = courseworks.count > 9 ? "" : " "
            cwBtnAmount.setTitle("\nCourseworks\r"+str+"         \(courseworks.count)\n", forState: .Normal)
            print("number of courseworks",courseworks.count)
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
}