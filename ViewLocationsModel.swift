//
//  ViewLocationsModel.swift
//  MealTracker
//
//  Created by bgardell on 11/21/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import Foundation

class ViewLocationsModel
{
    var mealId : Int? // For querying purposes
    var mealData : MealData?
    var dayName : String?
    var currentRestaurant: Int?
    var restaurantIds : [Int]? // For querying purposes
}