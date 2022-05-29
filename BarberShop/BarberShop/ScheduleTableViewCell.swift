//
//  ScheduleTableViewCell.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/29/22.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgSchedule: UIImageView!
    @IBOutlet weak var nameSchedule: UILabel!
    @IBOutlet weak var dateSchedule: UILabel!
    @IBOutlet weak var priceSchedule: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
