//
//  AddLocation.swift
//  MealTracker
//
//  Created by bgardell on 11/20/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class AddLocation: UIViewController {
    
    var mealId : Int?
    var dayName : String?
    
    @IBOutlet weak var nameEntry: UITextField!
    @IBOutlet weak var addressEntry: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveLocation(sender: AnyObject) {
        let viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: viewContext) as! Restaurant
        restaurant.name = self.nameEntry.text
        restaurant.address = self.addressEntry.text
        let restaurantId = TestData.getRandNum(50000)
        restaurant.id = NSDecimalNumber(integer: restaurantId)
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSDecimalNumber(integer: self.mealId!))
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let mealData = fetchResults![0]
                mealData.restaurants!.append(restaurantId)
             }
        }
        
        performSegueWithIdentifier("saveLoc", sender: self)
    }



    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewLoc = segue.destinationViewController as? ViewLocations
        {
            viewLoc.mealId = self.mealId!
            viewLoc.dayName = self.dayName!
        }
    }

}
