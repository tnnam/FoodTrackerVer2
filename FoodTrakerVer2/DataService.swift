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
    
    var kinds = ["Sashimi", "Sushi", "Chiên & Nướng", "Khai vị", "Mỳ", "Đồ uống"]
    
//    var ref: DatabaseReference!
//
//    func loadData(with kind: String) -> [Meal] {
//        var newItem: [Meal] = []
//        ref = Database.database().reference(withPath: "sashimi")
//        ref.queryOrdered(byChild: "id").observe(.value) { (snapshot) in
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot {
//                    if let mealItem = Meal(snapshot: snapshot) {
//                        newItem.append(mealItem)
//                        print("NamTN: \(newItem[0].name)")
//                    }
//                }
//            }
//        }
//        return newItem
//    }

    
}
