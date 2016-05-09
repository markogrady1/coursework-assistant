//
//  Coursework+CoreDataProperties.swift
//  native3.0
//
//  Created by Mark O'Grady on 07/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Coursework {

    @NSManaged var courseworkName: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var level: NSNumber?
    @NSManaged var markAwarded: NSNumber?
    @NSManaged var moduleName: String?
    @NSManaged var notes: String?
    @NSManaged var reminder: NSDate?
    @NSManaged var startDate: NSDate?
    @NSManaged var courseworkToTask: NSSet?

}
