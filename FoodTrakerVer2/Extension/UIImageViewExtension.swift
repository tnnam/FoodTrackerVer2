//
//  UIImageViewExtension.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/8/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

extension UIImageView {
    func download(from urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
