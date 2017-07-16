//
//  FoodItemDetailViewController.swift
//  MealTracker
//
//  Created by bgardell on 11/10/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit

class FoodItemDetailViewController: UIViewController {
    
    var foodItem : FoodItem! //MODEL
    var foodId : Int! //Used for querying purposes
    var inventory : Inventory! //Used for querying purposes
    
    @IBOutlet weak var nameBox: UITextField!
    
    @IBOutlet weak var caloriesBox: UITextField!

    @IBOutlet weak var descriptionBox: UITextView!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewWillAppear(animated: Bool) {
        nameBox.text = foodItem.foodName
        caloriesBox!.text = String(foodItem!.calories!)
        descriptionBox.text = foodItem.foodDescription!
    }
    
    @IBAction func saveFoodItem(sender: AnyObject) {
        if ( foodId >= 0 )
        {
            foodItem.foodName = nameBox.text
            foodItem.calories = Int(caloriesBox.text!)
            foodItem.foodDescription = descriptionBox.text
            self.inventory.foodItems[foodId] = foodItem
        } else {
            foodItem.foodName = nameBox.text
            foodItem.calories = Int(caloriesBox.text!)
            self.inventory.foodItems.append(foodItem)
        }
        performSegueWithIdentifier("saveSegue", sender: sender)
    
    }
        
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let invView = segue.destinationViewController as? InventoryViewController
        {
            if ( segue.identifier != "backToInv" )
            {
                invView.inventory = self.inventory
            }
        }
        
     }
    
}
