//
//  Location.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/7/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationGG {
    var name: String
    var formattedAddress: String
    var coordinate: CLLocationCoordinate2D
    
    init?(name: String, formattedAddress: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.formattedAddress = formattedAddress
        self.coordinate = coordinate
    }
}
