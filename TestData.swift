//
//  TestData.swift
//  MealTracker
//
//  Created by bgardell on 11/10/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TestData {
    static var week = Week()
    static var days : [DayData] = []
    static var inventory = Inventory()
    static var allMeals = [MealData]()
    static var foodNames = ["banana", "rice", "pudding", "pizza", "dough", "water", "stew", "wellington", "beef", "chicken", "pork", "curry",
                            "basil", "bake"]
    static var mealImages = ["food-dinner-lemon-rice-medium.jpg",
                             "food-salad-healthy-lunch-medium.jpg",
                             "food-salad-restaurant-person-medium.jpg",
                             "hamburger-food-meal-tasty-47725-medium.jpeg",
                             "pexels-photo-132694-medium.jpeg",
                             "pexels-photo-139374-medium.jpeg",
                             "pexels-photo-196643-medium.jpeg",
                             "pexels-photo-63943-medium.jpeg",
                             "pexels-photo-64208-medium.jpeg",
                             "pexels-photo-70497-medium.jpeg",
                             "pexels-photo-medium.jpg",
                             "potatoes-french-mourning-funny-162971-medium.jpeg",
                             "vegetables-vegetable-basket-harvest-garden-medium.jpg"]
    static var dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    static var done =  false
    

    
    static func setupAllTestData()
    {
        if ( !done )
        {
            setupInventory()
            setupMeals()
            done = true
        }
    }
    
    static func setupInventory()
    {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        for ( var i = 0; i < 200; i += 1 )
        {
            let foodItem = NSEntityDescription.insertNewObjectForEntityForName("FoodItem", inManagedObjectContext: viewContext) as! FoodItem
            foodItem.foodName = foodNames[ getRandNum(foodNames.count) ] + " " + foodNames[ getRandNum(foodNames.count) ]
            foodItem.calories = getRandNum( 450 )
            foodItem.foodId = i
            foodItem.foodDescription = ""
            for ( var j = 0 ; j < 8 ; j += 1 )
            {
                foodItem.foodDescription = foodItem.foodDescription! + foodNames[ getRandNum(foodNames.count) ] + " "
            }
            do {
                try insertContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            self.inventory.foodItems.append(foodItem)
        }

    }
    
    static func setupMeals()
    {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        for i in 0...10
        {
            let mealData = NSEntityDescription.insertNewObjectForEntityForName("MealData", inManagedObjectContext: viewContext) as! MealData
            mealData.name = foodNames[ getRandNum(foodNames.count) ] + " " + foodNames[ getRandNum(foodNames.count) ]
            mealData.id = NSDecimalNumber(integer: i)
            mealData.foodItems = [Int]()
            for j in 0...3
            {
                mealData.foodItems!.append( getRandNum(inventory.foodItems.count) )
            }
            mealData.mealDescription = ""
            for _ in 0...8
            {
                mealData.mealDescription = mealData.mealDescription! + foodNames[ getRandNum(foodNames.count) ] + " "
            }
            mealData.mealImage = UIImagePNGRepresentation( UIImage(named: mealImages[ getRandNum( mealImages.count )])! )
            mealData.restaurants = []
            allMeals.append(mealData)
        }
        do {
            try insertContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    
    static func setupWeek()
    {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        for ( var i = 0; i < 7; i += 1 )
        {
            let day = NSEntityDescription.insertNewObjectForEntityForName("DayData", inManagedObjectContext: viewContext) as! DayData
            day.dayName = dayNames[i]
            
            day.breakfastMealId = NSDecimalNumber(integer: -1)
            day.dinnerMealId = NSDecimalNumber(integer: -2)
            day.lunchMealId = NSDecimalNumber(integer: -3)
            
            days.append(day)
            do {
                try insertContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }

    }
    
    static func getRandNum(num:Int) -> Int
    {
        let int32 = UInt32(num)
        return Int(arc4random_uniform(int32))
    }
}
