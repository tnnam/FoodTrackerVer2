//
//  DataService.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/6/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

typealias DICT = Dictionary<AnyHashable, Any>

class DataService {
    
    static let shared: DataService = DataService()
    
    var kinds = ["Sashimi", "Sushi", "Chiên, nướng", "Khai Vị", "Mỳ", "Đồ uống"]
    
    // MARK: Meal
    
    func getData(key: String, complete: ([Meal]) -> Void) {
        var meals: [Meal] = []
        guard let path = Bundle.main.path(forResource: "Meals", ofType: "plist") else { return }
        guard let data = FileManager.default.contents(atPath: path) else { return }
        guard let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) else { return }
        guard let dict = result as? DICT else { return }
        guard let dataMeals = dict[key] as? [DICT] else { return }
        for meal in dataMeals {
            if let mealObj = Meal(value: meal) {
                meals.append(mealObj)
            }
        }
        complete(meals)
    }
    
}
