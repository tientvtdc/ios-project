//
//  User.swift
//  BarberShop
//
//  Created by Thanh Tuan Hang on 5/25/22.
//

import UIKit

class User{
    var id:Int
    var name:String
    var phone:String
    var image:UIImage
    var role:Int
    
    init(id:Int, name:String, phone:String, imageName:String, role:Int){
        self.id = id
        self.name = name
        self.phone = phone
        if let image = UIImage(named: imageName){
            self.image = image
        }
        else{
            self.image = UIImage(named: "default")!
        }
        self.role = role
    }
    
    
}

