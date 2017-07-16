//
//  MealCell.swift
//  MealTracker
//
//  Created by bgardell on 11/10/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit

class MealCell: UICollectionViewCell {
    
    var meal: MealData?
    var mealId : Int?
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealCalories: UILabel!
    @IBOutlet weak var mealImage: UIButton!
    var parentController: MealViewController?
    @IBAction func imageClicked(sender: AnyObject) {
        parentController!.imageClicked(self);
    }
    
    var cellImg : UIImage?
}
