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
    var releaseDate: NSDate?
    var courseworks: [Coursework]!
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext? = nil
    var percentageLabel:UILabel!
    var countDownLabel:UILabel!
    var timer:NSTimer!
    @IBOutlet weak var courseworkNumber: UILabel!
    @IBOutlet weak var cwBtnAmount: UIButton!
 var dates = [NSDate]()
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "courseworkListFromHome"{
            navigationItem.title = "Done"
        }
        if segue.identifier == "addCourseworkFromHome"{
            navigationItem.title = "Done"
        }
    }
    override func viewWillDisappear(animated: Bool) {
        dates.removeAll()
        percentageLabel.removeFromSuperview()
        countDownLabel.removeFromSuperview()
        if(timer != nil) {
             timer.invalidate()
        }
       
        countDownLabel.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        
        countDownLabel = UILabel(frame: CGRectMake(480, 80, 480, 81))
        countDownLabel.text = ""
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
            var startDates = [NSDate]()
            for(var i = 0; i < courseworks.count; i++) {
                if courseworks[i].dueDate != nil {
                    dates.append(courseworks[i].dueDate!)
                    if(courseworks[i].startDate != nil){
                        startDates.append(courseworks[i].startDate!)
                    } else {
                        startDates.append(NSDate())

                    }
                    if(dates.count == 0) {
                        
                    }
                  //  startDates.append(courseworks[i].startDate!)
                }
            }
                let toodayUnixTime = NSDate().timeIntervalSince1970

                dates.sortInPlace({ abs($0.timeIntervalSince1970 - toodayUnixTime) < abs($1.timeIntervalSince1970 - toodayUnixTime) })

            
            percentageLabel = UILabel(frame: CGRectMake(280, 80, 180, 81))
            percentageLabel.removeFromSuperview()
            countDownLabel.removeFromSuperview()
            countDownLabel.text = ""
            if(timer != nil) {
                timer.invalidate()
            }
            percentageLabel.center = CGPointMake(175, 512)
            percentageLabel.textAlignment = NSTextAlignment.Center
            percentageLabel.font = .systemFontOfSize(27)
            percentageLabel.textColor = helper.hexStringToUIColor("ffffff")
            percentageLabel.lineBreakMode = .ByWordWrapping
            self.view.addSubview(percentageLabel)

           let percentageLabel2 = UILabel(frame: CGRectMake(80, 80, 180, 81))
            percentageLabel2.center = CGPointMake(175, 472)
            percentageLabel2.textAlignment = NSTextAlignment.Center
            percentageLabel2.font = .systemFontOfSize(17)
//            percentageLabel2.backgroundColor = helper.hexStringToUIColor("ff0000")

            percentageLabel2.textColor = helper.hexStringToUIColor("ffffff")
            percentageLabel2.lineBreakMode = .ByWordWrapping
            percentageLabel2.text = "Closest due date"
            self.view.addSubview(percentageLabel2)

            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            if(dates.count != 0) {
                 let dateString = formatter.stringFromDate(dates[0])
            var strArr = dateString.componentsSeparatedByString(",")
            strArr = strArr[0].componentsSeparatedByString(" ")
            let month = String(strArr[0].characters.prefix(3))// get first 3 chars
             percentageLabel.text = month + " " + strArr[1]

                let releaseDateFormatter = NSDateFormatter()
                let dstr = String(dates[0])
                let releaseDateString = dstr.componentsSeparatedByString(" +")
                
                releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                releaseDate = releaseDateFormatter.dateFromString(releaseDateString[0])!
                
               timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDownDate", userInfo: nil, repeats: true)

            } else {
                percentageLabel.removeFromSuperview()
                countDownLabel.removeFromSuperview()
                countDownLabel.text = ""
                if(timer != nil) {
                    timer.invalidate()
                }
                
            }
        
                   } catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    func countDownDate() {
        countDownLabel.removeFromSuperview()
        let currentDate = NSDate()
        
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: currentDate, toDate: releaseDate!, options: .MatchFirst)
        
        let countdown = "Months: \(diffDateComponents.month), Days: \(diffDateComponents.day), Hours: \(diffDateComponents.hour), Minutes: \(diffDateComponents.minute), Seconds: \(diffDateComponents.second)"
        
        countDownLabel.center = CGPointMake(405, 672)
        countDownLabel.textAlignment = NSTextAlignment.Center
        countDownLabel.font = .systemFontOfSize(17)
        //            percentageLabel2.backgroundColor = helper.hexStringToUIColor("ff0000")
        
        countDownLabel.textColor = helper.hexStringToUIColor("ffffff")
        countDownLabel.lineBreakMode = .ByWordWrapping
        let countArray = countdown.componentsSeparatedByString("-")
        if countArray.count > 1 {
            countDownLabel.text = "DUE DATE PASSED"
            countDownLabel.center = CGPointMake(175, 612)
        } else {
            countDownLabel.text = countdown
        }
        
        self.view.addSubview(countDownLabel)

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
        } catch let error as NSError {
            print("Error: \(error)")
        }
            }
    
 
}