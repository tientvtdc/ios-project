//
//  User.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/29/22.
//

import UIKit

class User: NSObject {
    var id: String
    var name: String
    var phone: String
    var image: String = ""
    var role: Int
    
    override init() {
        self.id = ""
        self.name = ""
        self.phone = ""
        self.role = 0
    }
    
    init(id: String, name: String, phone: String, role: Int) {
        
        self.id = id
        self.name = name
        self.phone = phone
        self.role = role
    }
}
