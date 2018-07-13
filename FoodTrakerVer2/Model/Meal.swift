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
    
    var ref: DatabaseReference?
    var id: String = ""
    var name: String = ""
    var photo: String = ""
    var rating: Int = -1
    var price: Int = -1
    var location: Location
    var time: Time
    var shortDesc:  String = ""
    var review: String = ""
    
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
    
    init?(value: DICT) {
        let id = value["ID"] as? String ?? ""
        let name = value["Name"] as? String ?? ""
        let photo = value["Photo"] as? String ?? ""
        let rating = value["Rating"] as? Int ?? -1
        let price = value["Price"] as? Int ?? -1
        let location = value["Location"] as? DICT ?? [:]
        let locationData = Location(value: location)
        let time = value["Time"] as? DICT ?? [:]
        let timeData = Time(value: time)
        let shortDesc = value["ShortDesc"] as? String ?? ""
        let review = value["Review"] as? String ?? ""
        
        ref = nil
        self.id = id
        self.name = name
        self.photo = photo
        self.rating = rating
        self.price = price
        self.location = locationData ?? Location(name: "", formattedAddress: "", coordinate: Coordinate(latitude: "", longitude: ""))
        self.time = timeData ?? Time(start: "", end: "")
        self.shortDesc = shortDesc
        self.review = review
    }

    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? DICT ?? [:]
        let id = value["id"] as? String ?? ""
        let name = value["name"] as? String ?? ""
        let photo = value["photo"] as? String ?? ""
        let rating = value["rating"] as? Int ?? -1
        let price = value["price"] as? Int ?? -1
        let location = value["location"] as? DICT ?? [:]
        let locationData = Location(dict: location)
        let time = value["time"] as? DICT ?? [:]
        let timeData = Time(dict: time)
        let shortDesc = value["shortDesc"] as? String ?? ""
        let review = value["review"] as? String ?? ""
        
        ref = snapshot.ref
        self.id = id
        self.name = name
        self.photo = photo
        self.rating = rating
        self.price = price
        self.location = locationData ?? Location(name: "", formattedAddress: "", coordinate: Coordinate(latitude: "", longitude: ""))
        self.time = timeData ?? Time(start: "", end: "")
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
            "location": [
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
