//
//  UserDetailViewController.swift
//  BarberShop
//
//  Created by Thanh Tuan Hang on 5/27/22.
//

import UIKit
import iOSDropDown

class UserDetailViewController: UIViewController {
    var user:User?
    
    @IBOutlet weak var userDetailImg: UIImageView!
    @IBOutlet weak var userDetailName: UILabel!
    @IBOutlet weak var userDetailTel: UILabel!
    @IBOutlet weak var userDetailRole: DropDown!
    
    @IBOutlet weak var userBtnSave: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetailName.text = user?.name
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}

