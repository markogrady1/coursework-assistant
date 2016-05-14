//
//  Task+CoreDataProperties.swift
//  native3.0
//
//  Created by Mark O'Grady on 14/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var completedAmount: NSNumber?
    @NSManaged var courseworkName: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var lengthOfTime: NSNumber?
    @NSManaged var notes: String?
    @NSManaged var reminder: NSNumber?
    @NSManaged var startDate: NSDate?
    @NSManaged var taskName: String?
    @NSManaged var taskToCoursework: Coursework?

}
