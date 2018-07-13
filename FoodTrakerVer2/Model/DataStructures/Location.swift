//
//  Location.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/5/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class Location {
    var name: String = ""
    var formattedAddress: String = ""
    var coordinate: Coordinate
    
    init(name: String, formattedAddress: String, coordinate: Coordinate) {
        self.name = name
        self.formattedAddress = formattedAddress
        self.coordinate = coordinate
    }
    
    init?(value: DICT) {
        let name = value["Name"] as? String ?? ""
        let formattedAddress = value["FormattedAddress"] as? String ?? ""
        let coordinate = value["Coordinate"] as? DICT ?? [:]
        let coordinateData = Coordinate(value: coordinate)
        self.name = name
        self.formattedAddress = formattedAddress
        self.coordinate = coordinateData ?? Coordinate(latitude: "", longitude: "")
    }
    
    init?(dict: DICT) {
        let name = dict["name"] as? String ?? ""
        let formattedAddress = dict["formattedAddress"] as? String ?? ""
        let coordinate = dict["coordinate"] as? DICT ?? [:]
        let coordinateData = Coordinate(dict: coordinate)
        self.name = name
        self.formattedAddress = formattedAddress
        self.coordinate = coordinateData ?? Coordinate(latitude: "", longitude: "")
    }
}
