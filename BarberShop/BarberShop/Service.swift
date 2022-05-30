//
//  Service.swift
//  BarberShop
//
//  Created by Truong Tien on 5/22/22.
//

import Foundation

class Service {
    var id = "";
    var  name = "";
    var image = "";
    var price = 0.0;
    var description = "";
    var time = 0;
    var create_at = Date.init();
    
    init() {
        self.id = ""
        self.name = ""
        self.image = ""
        self.price = 0.0
        self.description = ""
        self.time = 0
    }
    
    init(id:String,name:String, image:String ,price:Double ,description:String ,time:Int) {
        self.id = id;
        self.name = name;
        self.image = image;
        self.price = price;
        self.description = description;
        self.time = time;
    }
}


