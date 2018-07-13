//
//  Coordinate.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/5/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class Coordinate {
    var latitude: String = ""
    var longitude: String = ""
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(value: DICT) {
        let latitude = value["Latitude"] as? String ?? ""
        let longitude = value["Longitude"] as? String ?? ""
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(dict: DICT) {
        let latitude = dict["latitude"] as? String ?? ""
        let longitude = dict["longitude"] as? String ?? ""
        self.latitude = latitude
        self.longitude = longitude
    }
}
