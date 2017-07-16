//
//  ViewLocations.swift
//  MealTracker
//
//  Created by bgardell on 11/20/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class ViewLocations: UIViewController {
    
    var mealId : Int? // For querying purposes
    var mealData : MealData?
    var dayName : String?
    var currentRestaurant: Int?
    var restaurantIds : [Int]? // For querying purposes
    
    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.mealData = fetchResults![0]
                self.restaurantIds = self.mealData!.restaurants!
                if ( self.restaurantIds!.count != 0 )
                {
                    currentRestaurant = 0
                    setupRestaurant(currentRestaurant!)
                }
            } else {
                restaurantName!.text = ""
                address!.text = "No Locations Added Yet!"
            }
        } else {
            restaurantName!.text = ""
            address!.text = "No Locations Added Yet!"
        }
    }
    
    func setupRestaurant(index: Int)
    {
        let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSDecimalNumber(integer: restaurantIds![index]))
        var fetchResults : [Restaurant]?
        do {
            fetchResults = try insertContext.executeFetchRequest(fetchRequest) as? [Restaurant]
        } catch _ {
            fetchResults = nil
        }
        
        if fetchResults != nil {
            if fetchResults!.count != 0 {
                let restaurant = fetchResults![0]
                self.address!.text = restaurant.address!
                self.restaurantName!.text = restaurant.name!
                
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString( address.text!, completionHandler: { (placemarks: [CLPlacemark]?, error:NSError?) -> Void in
                    
                    if ( error != nil )
                    {
                        print (error)
                    }
                    
                    if let placemark = placemarks?[0] {
                        let lat = placemark.location!.coordinate.latitude
                        let long = placemark.location!.coordinate.longitude
                        let coord = CLLocation(latitude: lat, longitude: long)
                        
                        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(coord.coordinate, 500, 500), animated: true)
                    }
                })


            } else {
                self.address!.text = "No locations have been given for this meal!"
                self.restaurantName!.text = ""
            }
        }
    }
    
    @IBAction func next(sender: AnyObject) {
        if let _ = restaurantIds
        {
        if ( restaurantIds!.count > 0 )
        {
        if ( self.currentRestaurant! == restaurantIds!.count - 1 )
        {
            self.currentRestaurant = 0
            setupRestaurant(currentRestaurant!)
        } else {
            self.currentRestaurant! += 1
            setupRestaurant(currentRestaurant!)
        }
        }
        }
    }
    
    @IBAction func prev(sender: AnyObject) {
        if let _ = restaurantIds
        {
        if ( restaurantIds!.count > 0 )
        {
        if ( self.currentRestaurant! == 0 )
        {
            self.currentRestaurant = restaurantIds!.count - 1
            setupRestaurant(currentRestaurant!)
        } else {
            self.currentRestaurant! -= 1
            setupRestaurant(currentRestaurant!)
        }
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let addLoc = segue.destinationViewController as? AddLocation
        {
            addLoc.mealId = Int(self.mealData!.id!)
            addLoc.dayName = self.dayName!
        }
        if let dayView = segue.destinationViewController as? DayViewController
        {
            dayView.dayName = self.dayName!
        }
    }

}
