//
//  TitleViewController.swift
//  MealTracker
//
//  Created by bgardell on 10/17/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData

class TitleViewController: UIViewController {
    
    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "MealData")
        fetchRequest.predicate = nil
        var fetchResults : [MealData]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [MealData]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                
            } else {
                TestData.setupAllTestData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
