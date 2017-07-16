//
//  FoodItemCell.swift
//  MealTracker
//
//  Created by bgardell on 11/19/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class FoodItemCell: UICollectionViewCell {
    
    @IBOutlet weak var foodName: UILabel!
    var mealId : Int?
    var foodId : Int?
    var parentViewController : MealDetailView?
    
    @IBAction func deleteFoodItem(sender: AnyObject) {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSDecimalNumber(integer: mealId!))
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let managedObject = fetchResults![0]
                var foodIds = managedObject.foodItems!
                if ( foodIds.count > 0 )
                {
                for i in 0...foodIds.count - 1
                {
                    if ( foodIds[i] == foodId! )
                    {
                        foodIds.removeAtIndex(i)
                        break
                    }
                }
                managedObject.foodItems = foodIds
                
                do {
                    try insertContext.save()
                    var foodNames = [FoodItem]()
                    let foodItems = managedObject.foodItems!
                    for foodId in foodItems {
                        let fetchRequest = NSFetchRequest(entityName: "FoodItem")
                        fetchRequest.predicate = NSPredicate(format: "foodId == %d", foodId)
                        var fetchResults : [FoodItem]?
                        do {
                            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [FoodItem]
                        } catch _ {
                            fetchResults = nil
                        }
                        
                        if fetchResults != nil {
                            if fetchResults!.count != 0 {
                                let foodItem = fetchResults![0]
                                foodNames.append(foodItem)
                            }
                        }
                    }
                    parentViewController!.foodNames = foodNames
                    parentViewController?.collectionView.reloadData()
                    self.reloadInputViews()
                } catch _ {
                    
                }
                }
            }
        }
        
    }
}
