//
//  Location.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/5/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class Location {
    var name: String
    var formattedAddress: String
    var coordinate: Coordinate
    
    init(name: String, formattedAddress: String, coordinate: Coordinate) {
        self.name = name
        self.formattedAddress = formattedAddress
        self.coordinate = coordinate
    }
    
    init?(dict: DICT) {
        guard let name = dict["name"] as? String else { return nil }
        guard let formattedAddress = dict["formattedAddress"] as? String else { return nil }
        guard let coordinate = dict["coordinate"] as? DICT else { return nil }
        guard let coordinateData = Coordinate(dict: coordinate) else { return nil }
        self.name = name
        self.formattedAddress = formattedAddress
        self.coordinate = coordinateData
    }
}
