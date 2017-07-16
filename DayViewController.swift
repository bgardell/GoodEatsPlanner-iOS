//
//  DayViewController.swift
//  MealTracker
//
//  Created by bgardell on 10/17/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController {
    
    var day: DayData? //MODEL
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealDesc: UITextView!
    @IBOutlet weak var prev: UIButton!
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var currMealName: UILabel!
    @IBOutlet weak var mealName: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "DayData")
        fetchRequest.predicate = NSPredicate(format: "dayName == %@", self.dayName!)
        var fetchResults : [DayData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [DayData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                self.day = fetchResults![0]
            }
        } else {
            self.mealName.text = "This day has not been planned for!"
        }
        
        navBar.topItem!.title = day?.dayName!
        if let _ = currentMeal
        {
            
        } else {
            self.currentMeal = Int(self.day!.breakfastMealId!)
        }
        
        setupMealView(currentMeal!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentMeal: Int?
    var dayName: String?

    @IBAction func prev(sender: AnyObject) {
        
        if ( currentMeal == getInt(day!.breakfastMealId!) )
        {
            currentMeal = getInt(day!.dinnerMealId!)
        }
            
        else if ( currentMeal == getInt(day!.lunchMealId!) )
        {
            currentMeal = getInt(day!.breakfastMealId!)
        }
            
        else if ( currentMeal == getInt(day!.dinnerMealId!)  )
        {
            currentMeal = getInt(day!.lunchMealId!)
        }
        
        setupMealView(currentMeal!)
    }
    
    @IBAction func next(sender: AnyObject) {
        if ( currentMeal == getInt(day!.breakfastMealId!) )
        {
            currentMeal = getInt(day!.lunchMealId!)
        }
        
        else if ( currentMeal == getInt(day!.lunchMealId!) )
        {
            currentMeal = getInt(day!.dinnerMealId!)
        }
        
        else if ( currentMeal == getInt(day!.dinnerMealId!)  )
        {
            currentMeal = getInt(day!.breakfastMealId!)
        }
        
        setupMealView(currentMeal!)
    }
    
    func setupMealView(currentMealId : Int)
    {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSDecimalNumber(integer: currentMealId))
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let currMeal = fetchResults![0]
                self.mealName.text = currMeal.name
                self.mealImage.image = UIImage(data: currMeal.mealImage!)
                self.mealDesc.text = currMeal.mealDescription
            } else {
                self.mealImage.image = nil
                self.mealDesc.text = "This meal has not been planned for!"
                self.mealName.text = "This meal has not been planned for!"
            }
            switch (currentMeal!)
            {
            case getInt(day!.breakfastMealId!):
                self.currMealName!.text = "Breakfast"
                break
            case getInt(day!.lunchMealId!):
                self.currMealName!.text = "Lunch"
                break
            case getInt(day!.dinnerMealId!):
                self.currMealName!.text = "Dinner"
                break
            default:
                self.currMealName!.text = "Breakfast"
                break
            }
        }
        
        self.reloadInputViews()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mealView = segue.destinationViewController as? MealViewController {
            mealView.day = self.day
            mealView.selectingMeal = true
            switch (currentMeal!)
            {
            case getInt(day!.breakfastMealId!):
                mealView.mealChanged = "breakfast"
                break
            case getInt(day!.lunchMealId!):
                mealView.mealChanged = "lunch"
                break
            case getInt(day!.dinnerMealId!):
                mealView.mealChanged = "dinner"
                break
            default:
                mealView.mealChanged = "breakfast"
                break
            }
        }
        if let _ = segue.destinationViewController as? WeekViewController {
            
        }
        if let viewLocations = segue.destinationViewController as? ViewLocations {
            viewLocations.mealId = self.currentMeal!
            viewLocations.dayName = self.day?.dayName!
        }
    }
    

    
    func getInt(num : NSDecimalNumber ) -> Int
    {
        return Int(num)
    }

}
