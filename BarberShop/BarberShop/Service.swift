//
//  Service.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/22/22.
//

import UIKit

class Service {
    // MARK: properties
    public var name:String = "";
    public var price:Int;
    public var des:String;
    public var time:Int;
    public var image:UIImage?;
    // MARK: contructors
    init?(name: String, price:Int, des:String, time:Int, image:UIImage?) {
        self.name = name;
        self.price = price;
        self.des = des;
        self.time = time;
        self.image = image;
    }
}
