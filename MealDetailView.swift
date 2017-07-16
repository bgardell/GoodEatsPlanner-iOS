//
//  MealDetailView.swift
//  MealTracker
//
//  Created by bgardell on 11/10/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class MealDetailView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    var meal : MealData?
    var foodNames : [FoodItem]?
    var mealId: Int? // needed to query entity

    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealCalories: UITextField!
    @IBOutlet weak var mealDescription: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mealImage: UIButton!
    
    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        if meal != nil
        {
            mealName.text = meal?.name
            let cal = 0
            mealCalories.text = String(cal)
            mealDescription.text = meal?.mealDescription
            if mealImage!.backgroundImageForState(UIControlState.Normal) != nil
            {
            
            } else {
                self.mealImage!.setBackgroundImage(UIImage(data: meal!.mealImage!)!, forState: UIControlState.Normal)
            }
            
            var calories = 0
            foodNames = [FoodItem]()
            let foodItems = meal!.foodItems!
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
                        calories += Int(foodItem.calories!)
                        foodNames!.append(foodItem)
                    }
                }
            }
            
            mealCalories!.text = String(calories)
            
        } else {
            meal = NSEntityDescription.insertNewObjectForEntityForName("MealData", inManagedObjectContext: viewContext) as? MealData
            meal!.id = NSDecimalNumber(integer: TestData.getRandNum(5000))
            meal!.name = "Add a name"
            meal!.mealImage = UIImagePNGRepresentation(UIImage(named: "default.jpg")!)
            meal!.mealDescription = "Add a description"
            meal!.foodItems = [0]
        }
        
        self.hideKeyboardWhenTappedAround()

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.mealImage!.setBackgroundImage(info[UIImagePickerControllerOriginalImage] as? UIImage, forState: UIControlState.Normal)
    }
    
    @IBAction func changeImage(sender: AnyObject) {
        let photoPicker = UIImagePickerController ()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        // display image selection view
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func saveMeal(sender: AnyObject) {
        meal!.name = mealName.text!
        meal!.mealDescription = mealDescription.text!
        mealId = Int(meal!.id!)
        
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", meal!.id!)
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                
                let managedObject = fetchResults![0]
                managedObject.setValue(self.mealName.text, forKey: "name")
                managedObject.setValue(self.mealDescription.text, forKey: "mealDescription")
                managedObject.setValue(UIImagePNGRepresentation(self.mealImage!.backgroundImageForState(UIControlState.Normal)!), forKey: "mealImage")
                //managedObject.setValue(meal?.foodItems, forKey: "foodItems")
                
                do {
                    try insertContext.save()
                } catch _ {
                    
                }
                
            } else {
            
                do {
                    try insertContext.save()
                    print("TEST SAVE")
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
        
        performSegueWithIdentifier("saveMeal", sender: self)
    }
    
    @IBAction func deleteMeal(sender: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", meal!.id!)
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let managedObject = fetchResults![0]
                insertContext.deleteObject(managedObject)
                
                do {
                    try insertContext.save()
                } catch _ {
                    
                }
            }
        }
        
        performSegueWithIdentifier("saveMeal", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("foodItemCell", forIndexPath: indexPath) as! FoodItemCell
        
        let foodName = foodNames![ indexPath.row ].foodName!
        cell.foodName!.text = foodName
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.mealId = Int(self.meal!.id!)
        cell.foodId = Int( foodNames![indexPath.row].foodId! )
        cell.parentViewController = self
        cell.reloadInputViews()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = foodNames {
            
        } else {
            foodNames = [FoodItem]()
            let foodItems = meal!.foodItems!
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
                        foodNames!.append(foodItem)
                    }
                }
            }
        }
        return foodNames!.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is MealViewController
        {
            if segue.identifier == "saveMeal"
            {
                //mealView.meals = self.meals!
            }
        }
        
        if let vc = segue.destinationViewController as? InventoryViewController
        {
            vc.mealId = self.meal!.id!
            vc.meal = self.meal!
        }
    }
    
}
