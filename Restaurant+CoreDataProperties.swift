//
//  Restaurant+CoreDataProperties.swift
//  MealTracker
//
//  Created by bgardell on 11/20/16.
//  Copyright © 2016 bgardell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var name: String?
    @NSManaged var id: NSDecimalNumber?
    @NSManaged var address: String?

}
