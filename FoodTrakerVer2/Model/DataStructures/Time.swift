//
//  Time.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/5/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class Time {
    var start: String
    var end: String
    
    init(start: String, end: String) {
        self.start = start
        self.end = end
    }
    
    init?(dict: DICT) {
        guard let start = dict["start"] as? String else { return nil }
        guard let end = dict["end"] as? String else { return nil }
        self.start = start
        self.end = end
    }
}
