//
//  ServiceTableViewCell.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/23/22.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var nameService: UILabel!
    
    @IBOutlet weak var priceService: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
