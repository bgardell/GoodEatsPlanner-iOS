//
//  MealViewController.swift
//  MealTracker
//
//  Created by bgardell on 10/17/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class MealViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var day : DayData? //MODEL
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = true
        
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = nil
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        if fetchResults != nil {
            for result in fetchResults!
            {
                meals.append(result)
            }
        } else {
            meals = TestData.allMeals
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mealCell", forIndexPath: indexPath) as! MealCell

        let cellColor = UIColor(red: 80/255, green: 40/255, blue: 0/255, alpha: 0.55)
        
        cell.meal = meals[ indexPath.row ]
        let calories = getMealCalories(cell.meal!.id!)
        cell.mealCalories.text = String(calories)
        cell.mealName.text = cell.meal?.name
        
        if let img = meals[ indexPath.row ].mealImage
        {
            cell.cellImg = UIImage(data: img)
        }
        
        cell.mealImage.setImage(cell.cellImg, forState: UIControlState.Normal)
        
        cell.parentController = self
        cell.mealId = Int( meals[ indexPath.row ].id! )
        
        cell.contentView.backgroundColor = cellColor
        cell.mealName.backgroundColor = cellColor
        cell.mealCalories.backgroundColor = cellColor
        
        cell.reloadInputViews()

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let mealCell = collectionView.dequeueReusableCellWithReuseIdentifier("mealCell", forIndexPath: indexPath)
        
        performSegueWithIdentifier("mealDetail", sender: mealCell)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func imageClicked(sender: MealCell)
    {
        if ( selectingMeal == nil )
        {
            selectingMeal = false
        }
        
        if ( !selectingMeal! ) {
            performSegueWithIdentifier("mealDetail", sender: sender)
        } else {
            performSegueWithIdentifier("setMeal", sender: sender)
        }
    }
    
    var meals : [MealData] = []
    var mealChanged: String?
    var selectingMeal : Bool?
    
    func getMealCalories(mealId : NSDecimalNumber) -> Int
    {
        var calories = 0
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
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
                let mealData = fetchResults![0]
                for foodId in mealData.foodItems! {
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
                            calories += Int(foodItem.calories!)
                        }
                    }
                }
                
            }
        }
        
        return calories
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let mealDetailView = segue.destinationViewController as? MealDetailView
        {
            if let mealCell = sender as? MealCell
            {
                mealDetailView.meal = mealCell.meal
                mealDetailView.mealId = mealCell.mealId
            }
        }
        
        if let dayView = segue.destinationViewController as? DayViewController
        {
            if let mealCell = sender as? MealCell
            {
                dayView.dayName = self.day?.dayName!
                dayView.currentMeal = Int(mealCell.meal!.id!)
                let fetchRequest = NSFetchRequest(entityName: "DayData")
                fetchRequest.predicate = NSPredicate(format: "dayName == %@", self.day!.dayName!)
                print ( self.day!.dayName! )
                var fetchResults : [DayData]?
                do {
                    fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [DayData]
                } catch _ {
                    fetchResults = nil
                }
                if fetchResults != nil {
                    if fetchResults!.count != 0 {
                        let managedObject = fetchResults![0]
                        let mealName = self.mealChanged! + "MealId"
                        managedObject.setValue(mealCell.meal!.id, forKey: mealName)
                        
                        do {
                            try insertContext.save()
                        } catch _ {
                            
                        }
                    }
                }
            }
        }
        
    }

}