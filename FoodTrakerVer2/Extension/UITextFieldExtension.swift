//
//  UITextFieldExtension.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/7/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

extension UITextField {
    func displayText(text: String) {
        self.text = text
    }
    
    func displayLocation(location: LocationGG) {
        if location.name == "Vị trí của tôi" {
            self.text = "Vị trí của tôi"
        } else {
            self.text = "\(location.name), \(location.formattedAddress)"
        }
    }
}
