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
    var customer:User?
    var timeOrder: Date?
    var timeFinish: Date?
    var isFinish: Int?
    
    init(id:String, service:Service,customer:User, timeOrder:Date , timeFinish:Date, isFinish:Int) {
        self.id  = id ;
        self.service = service;
        self.customer = customer
        self.timeOrder = timeOrder;
        self.timeFinish = timeFinish;
        self.isFinish = isFinish;
    }
}
