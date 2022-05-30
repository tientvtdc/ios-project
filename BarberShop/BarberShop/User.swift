//
//  User.swift
//  BarberShop
//
//  Created by Truong Tien on 5/29/22.
//

import Foundation
class User {
    
    var name:String?
    var phone:String?
    var image:String?
    var id:String?
    var role:Int?
    
    init(id:String, name:String, phone:String, image:String) {
        self.id = id;
        self.name = name;
        self.phone = phone;
        self.image = image;
    }
    init(dictionary: [String: Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.phone = dictionary["phone"] as? String ?? ""
            self.image = dictionary["image"] as? String ?? ""
            self.role = Int((dictionary["role"] as? Int)!)
        }
}
