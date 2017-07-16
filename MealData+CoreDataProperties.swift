//
//  MealData+CoreDataProperties.swift
//  MealTracker
//
//  Created by bgardell on 11/18/16.
//  Copyright © 2016 bgardell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MealData {

    @NSManaged var id: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var mealDescription: String?
    @NSManaged var mealImage: NSData?
    @NSManaged var foodItems: [Int]?
    @NSManaged var restaurants: [Int]?

}
