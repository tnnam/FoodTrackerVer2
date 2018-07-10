//
//  Kind.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/5/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Kind {
    let ref: DatabaseReference?
    var kind: String
    var meal: Meal
    
    init(kind: String, meal: Meal) {
        ref = nil
        self.kind = kind
        self.meal = meal
    }
}
