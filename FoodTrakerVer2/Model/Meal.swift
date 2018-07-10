//
//  Meal.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/5/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Meal {
    let ref: DatabaseReference?
    var id: String
    var name: String
    var photo: String
    var rating: Int
    var price: Int
    var location: Location
    var time: Time
    var shortDesc:  String
    var review: String
    
    init(id: String, name: String, photo: String, rating: Int, price: Int, location: Location, time: Time, shortDesc:  String, review: String) {
        ref = nil
        self.id = id
        self.name = name
        self.photo = photo
        self.rating = rating
        self.price = price
        self.location = location
        self.time = time
        self.shortDesc = shortDesc
        self.review = review
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? DICT else { return nil }
        guard let id = value["id"] as? String else { return nil }
        guard let name = value["name"] as? String else { return nil }
        guard let photo = value["picture"] as? String else { return nil }
        guard let rating = value["rating"] as? Int else { return nil }
        guard let price = value["price"] as? Int else { return nil }
        guard let location = value["location"] as? DICT else { return nil }
        guard let locationData = Location(dict: location) else { return nil }
        guard let time = value["time"] as? DICT else { return nil }
        guard let timeData = Time(dict: time) else { return nil }
        guard let shortDesc = value["shortDesc"] as? String else { return nil }
        guard let review = value["review"] as? String else { return nil }
        
        ref = snapshot.ref
        self.id = id
        self.name = name
        self.photo = photo
        self.rating = rating
        self.price = price
        self.location = locationData
        self.time = timeData
        self.shortDesc = shortDesc
        self.review = review
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "photo": photo,
            "rating": rating,
            "price": price,
            "leasing": [
                "coordinate": [
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude
                ],
                "formattedAddress": location.formattedAddress,
                "name": location.name
            ],
            "time": [
                "start": time.start,
                "end": time.end
            ],
            "shortDesc": shortDesc,
            "review": review
        ]
    }
}
