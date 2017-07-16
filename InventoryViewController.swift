//
//  InventoryViewController.swift
//  MealTracker
//
//  Created by bgardell on 10/17/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class InventoryViewController: UITableViewController {
    
    var inventory : Inventory? // MODEL
    var mealId : NSDecimalNumber?
    var meal : MealData!
    
    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest(entityName: "FoodItem")
        fetchRequest.predicate = nil
        var fetchResults : [FoodItem]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [FoodItem]
        } catch _ {
            fetchResults = nil
        }
        if fetchResults != nil {
            inventory = Inventory()
            for result in fetchResults!
            {
                inventory!.foodItems.append(result)
            }
        } else {
            inventory = TestData.inventory
        }
        
        if let _ = mealId
        {
            self.backButton!.enabled = false
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.inventory?.foodItems.count)!
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("invCell", forIndexPath: indexPath) as! InventoryCell
        
        cell.foodItem = inventory?.foodItems[ indexPath.row ]
        cell.nameLabel.text = cell.foodItem?.foodName
        let calories = cell.foodItem?.calories! as Int!
        cell.calorieLabel.text = String(calories)
        cell.parentController = self
        cell.foodId = indexPath.row
     
        return cell
     }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = mealId
        {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", mealId!)
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let mealData = fetchResults![0]
                mealData.foodItems!.append( Int(self.inventory!.foodItems[indexPath.row].foodId!) )
                
                do
                {
                    try insertContext.save()
                    performSegueWithIdentifier("addFoodItem", sender: self)
                } catch _
                {
                    
                }
            }
        }
        
        
            
        }
    }
    
    func saveFoodItem(foodId: Int, foodItem: FoodItem)
    {
        inventory!.foodItems[foodId] = foodItem
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let foodEditView = segue.destinationViewController as? FoodItemDetailViewController
        {
            if let invCell = sender as? InventoryCell
            {
                foodEditView.foodId = invCell.foodId
                foodEditView.foodItem = invCell.foodItem
                foodEditView.inventory = self.inventory
            }
            else {
                foodEditView.foodId = -1
                foodEditView.foodItem = FoodItem()
                foodEditView.foodItem.calories = 0
                foodEditView.foodItem.foodDescription = ""
                foodEditView.foodItem.foodName = ""
                foodEditView.inventory = self.inventory
            }
        }
        
        if let mealView = segue.destinationViewController as? MealDetailView
        {
            mealView.meal = self.meal!
            mealView.mealId = Int(self.mealId!)
        }
        
    }

}
