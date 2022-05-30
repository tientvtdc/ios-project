//
//  User.swift
//  BarberShop
//
//  Created by Thanh Tuan Hang on 5/27/22.
//

import Foundation
class User {
    var id = ""
    var name = ""
    var phone = ""
    var image = ""
    var role = 0
    
    init(dictionary: [String: Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.phone = dictionary["phone"] as? String ?? ""
            self.image = dictionary["image"] as? String ?? ""
            self.role = Int((dictionary["role"] as? Int)!)
        }
    
    
}
