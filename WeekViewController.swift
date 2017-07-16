//
//  WeekViewController.swift
//  MealTracker
//
//  Created by bgardell on 10/17/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class WeekViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var weekTable: UITableView!
    var week : Week?
    var days : [DayData] = [] //MODEL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weekTable.delegate = self
        self.weekTable.dataSource = self
        if let _ = week
        {
            
        } else {
            self.week = TestData.week
        }
        self.weekTable.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "DayData")
        fetchRequest.predicate = nil
        var fetchResults : [DayData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [DayData]
        } catch _ {
            fetchResults = nil
        }
        if fetchResults != nil && fetchResults!.count > 0 {
            days = []
            for result in fetchResults!
            {
                   days.append(result)
            }
        } else {
            TestData.setupWeek()
            days = TestData.days
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! DayCell
        
        cell.parentViewController = self
        
        cell.day = days[indexPath.row]
        cell.dayName.text = cell.day?.dayName!
        let dayCalories = getCaloriesForDay(cell.day!.dayName!)
        cell.dayCal.text = String(dayCalories)
        if ( cell.day!.allMealsPlanned() )
        {
            cell.contentView.backgroundColor = UIColor.greenColor()
        } else {
            cell.contentView.backgroundColor = UIColor.redColor()
        }
        return cell
    }
    
    func getCaloriesForDay(dayName : String) -> Int
    {
        var calories = 0
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "DayData")
        fetchRequest.predicate = NSPredicate(format: "dayName == %@", dayName)
        var fetchResults : [DayData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [DayData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let day = fetchResults![0]
                calories += getMealCalories(day.breakfastMealId!)
                calories += getMealCalories(day.lunchMealId!)
                calories += getMealCalories(day.dinnerMealId!)
            }
        }
        return calories
    }
    
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
        if let dayView = segue.destinationViewController as? DayViewController
        {
            if let dayCell = sender as? DayCell
            {
                dayView.dayName = dayCell.dayName!.text!
            }
        }
        
        if let webView = segue.destinationViewController as? DayWebView
        {
            if let dayCell = sender as? DayCell
            {
                webView.dayHtmlString = dayCell.dayToHtml()
            }
        }
    }
    

}
