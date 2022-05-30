//
//  OrderManagementTableViewCell.swift
//  BarberShop
//
//  Created by Truong Tien on 5/30/22.
//

import UIKit

class OrderManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var finish: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
