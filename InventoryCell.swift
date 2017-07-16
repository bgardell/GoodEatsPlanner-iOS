//
//  InventoryCell.swift
//  MealTracker
//
//  Created by bgardell on 11/10/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit

class InventoryCell: UITableViewCell {
    var foodItem : FoodItem?
    var parentController : InventoryViewController?
    var foodId : Int?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    
    @IBAction func editFoodItem(sender: AnyObject) {
        parentController?.performSegueWithIdentifier("editFoodItem", sender: self)
    }
    
}
