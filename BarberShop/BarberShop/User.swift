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
    
    init(id:String, name:String, phone:String, image:String) {
        self.id = id;
        self.name = name;
        self.phone = phone;
        self.image = image;
    }
    
}
