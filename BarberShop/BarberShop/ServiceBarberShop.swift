//
//  ServiceBarberShop.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/25/22.
//

import Foundation
import UIKit

class ServiceBarberShop {
    var id:String
    var name: String
    var price: Int
    var des: String
    var time: Int
    var image: String
    
    init(id:String,name: String, price:Int, des:String,time:Int,image:String) {
        self.id = id
        self.name = name
        self.price = price
        self.des = des
        self.time = time
        self.image = image
    }
}
