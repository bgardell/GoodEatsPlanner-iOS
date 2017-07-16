//
//  DayCell.swift
//  MealTracker
//
//  Created by bgardell on 11/17/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class DayCell: UITableViewCell {
    
    var day : DayData?
    var parentViewController : WeekViewController?
    @IBOutlet weak var dayCal: UILabel!
    @IBOutlet weak var dayName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func goWeb(sender: AnyObject) {
        parentViewController!.performSegueWithIdentifier("dayToHtml", sender: self)
    }
    
    func dayToHtml() -> String
    {
        var dayHtml = ""
        dayHtml += getAllFoodItems(day!.breakfastMealId!)
        dayHtml += getAllFoodItems(day!.lunchMealId!)
        dayHtml += getAllFoodItems(day!.dinnerMealId!)
        return dayHtml
    }
    
    func getAllFoodItems(mealId: NSDecimalNumber) -> String
    {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var foodItems = ""
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", mealId)
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let currMeal = fetchResults![0]
                foodItems += "<h1>" + currMeal.name! + "</h1><br>"
                for foodId in currMeal.foodItems!
                {
                    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    
                    let fetchRequest = NSFetchRequest(entityName: "FoodItem")
                    fetchRequest.predicate = NSPredicate(format: "foodId == %@", NSDecimalNumber(integer: foodId))
                    var fetchResults : [FoodItem]?
                    do {
                        fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [FoodItem]
                    } catch _ {
                        fetchResults = nil
                    }
                    
                    if fetchResults != nil {
                        if fetchResults!.count != 0 {
                            let foodItem = fetchResults![0]
                            foodItems += "<li>" + foodItem.foodName! + " " + String(foodItem.calories!) + "</li>"
                        }
                    }
                }
                foodItems += "<br>"
            }
        }
        
        return foodItems
    }

}
