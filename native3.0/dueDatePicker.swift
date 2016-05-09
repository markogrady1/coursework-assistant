//
//  DueDatePicker.swift
//  native3.0
//
//  Created by Mark O'Grady on 07/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import Foundation
import UIKit

class DueDatePicker: UIViewController {
    var dueDate:NSDate!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dueDatePickerAction(sender: UIDatePicker) {
        dueDate = dueDatePicker.date
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDueDate" {
            let addCourseworkVC:AddCourseworkVC = segue.destinationViewController as! AddCourseworkVC
            //write both label values to NSUserDefaults
          
            //ensure tapeViewController recieves a correctly formatted string with calculations on seperate lines
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            var strDate = dateFormatter.stringFromDate(dueDate)
//            self.selectedDate.text = strDate

            addCourseworkVC. = dueDate
        }
        
    }

}