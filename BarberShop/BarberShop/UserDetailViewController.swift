//
//  UserDetailViewController.swift
//  BarberShop
//
//  Created by Thanh Tuan Hang on 5/27/22.
//

import UIKit
import FirebaseStorage;
import FirebaseDatabase
import Firebase;
import iOSDropDown

class UserDetailViewController: UIViewController {
    // MARK: Fields
    var user:User?
    var ref:DatabaseReference?
    @IBOutlet weak var userDetailRole: DropDown!
    @IBOutlet weak var userDetailImg: UIImageView!
    @IBOutlet weak var userDetailName: UILabel!
    @IBOutlet weak var userDetailTel: UILabel!
    
    // MARK: Set button save event listener
    @IBAction func btnSaveUser(_ sender: Any) {
        var role = 0
        if userDetailRole.text == "Admin"{
            role = 1
        }
        else if userDetailRole.text == "User"{
            role = 0
        }
        else{
            role = user!.role
        }
        
        ref = Database.database().reference();
        ref?.child("users/\(user!.id)/role").setValue(role)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Initiation
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailRole.optionArray = ["User", "Admin"]
        userDetailRole.arrowSize = 20
        if let userReceive = user{
            userDetailName.text = userReceive.name
            userDetailTel.text = userReceive.phone
            userDetailRole.text = userReceive.role == 1 ? "Admin" : "User"
            let url = URL(string: userReceive.image)
            userDetailImg.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_pic"));
        }
        userDetailImg.layer.cornerRadius = userDetailImg.frame.height / 2
    }
}

