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
import FirebaseAuth
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
        if userDetailRole.text == "Quản Lý"{
            role = 1
        }
        else if userDetailRole.text == "Người Dùng"{
            role = 0
        }
        else if userDetailRole.text == "Quản Trị Viên"{role = 2}
        else{
            role = user!.role!
        }
        
        ref = Database.database().reference();
        let id = user!.id!
        ref?.child("users/\(id)/role").setValue(role)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Initiation
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userDetailRole.optionArray = ["Quản Trị Viên", "Người Dùng", "Quản Lý"];
 
        if let userReceive = user{
            if userReceive.role == 2{
                userDetailRole.text = "Quản Trị Viên"
            }
            else if userReceive.role == 1{
                userDetailRole.text = "Quản Lý"
            }
            else{
                userDetailRole.text = "Người Dùng"
            }
         
            userDetailRole.arrowSize = 20
            userDetailName.text = userReceive.name
            userDetailTel.text = userReceive.phone
            let url = URL(string: userReceive.image!)
            userDetailImg.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_pic"));
        }
        userDetailImg.layer.cornerRadius = userDetailImg.frame.height / 2
    }
}
