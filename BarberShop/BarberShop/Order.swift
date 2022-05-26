//
//  Order.swift
//  BarberShop
//
//  Created by Truong Tien on 5/26/22.
//

import Foundation

class Order {
    var id: String?
    var service:Service?
    var customer:String?
    var timeOrder: Date?
    var timeFinish: Date?
    var isFinish:Bool?
    
    init(id:String, service:Service, timeOrder:Date , timeFinish:Date, isFinish:Bool) {
        self.id  = id ;
        self.service = service;
        self.timeOrder = timeOrder;
        self.timeFinish = timeFinish;
        self.isFinish = isFinish;
    }
}
