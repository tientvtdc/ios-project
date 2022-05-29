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
    
    init(id:String, name:String, phone: String, image: String, role:Int) {
        self.id  = id ;
        self.name = name;
        self.phone = phone
        self.image = image
        self.role = role
    }
}
