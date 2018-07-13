//
//  Time.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/5/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class Time {
    var start: String = "0:00"
    var end: String = "0:00"
    
    init(start: String, end: String) {
        self.start = start
        self.end = end
    }
    
    init?(value: DICT) {
        let start = value["Start"] as? String ?? "0:00"
        let end = value["End"] as? String ?? "0:00"
        self.start = start
        self.end = end
    }
    
    init?(dict: DICT) {
        let start = dict["start"] as? String ?? "0:00"
        let end = dict["end"] as? String ?? "0:00"
        self.start = start
        self.end = end 
    }
}
