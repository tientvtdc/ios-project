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
    var finish:Int?
    
    init(id:String, service:Service, timeOrder:Date , timeFinish:Date, finish:Int) {
        self.id  = id ;
        self.service = service;
        self.timeOrder = timeOrder;
        self.timeFinish = timeFinish;
        self.finish = finish;
    }
    init(id:String, service:Service, timeOrder:Date , timeFinish:Date, finish:Int,customer:User) {
        self.id  = id ;
        self.service = service;
        self.timeOrder = timeOrder;
        self.timeFinish = timeFinish;
        self.finish = finish;
        self.customer = customer;
    }
}
