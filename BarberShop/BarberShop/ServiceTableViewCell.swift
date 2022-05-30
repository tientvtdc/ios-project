//
//  MovieTableViewCell.swift
//  HamburgerMenu
//
//  Created by Kashyap on 13/11/20.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var timeForService: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
        
}
