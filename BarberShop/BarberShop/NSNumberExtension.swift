//
//  NSNumberExtension.swift
//  BarberShop
//
//  Created by Truong Tien on 5/24/22.
//

import Foundation

extension NSNumber{
    func toVND()->String{
        let formater = NumberFormatter();
        formater.numberStyle = .currency;
        formater.maximumFractionDigits = 0;
        formater.locale = Locale(identifier: "vi-VN");
        return formater.string(from: self)!;
    }
}
