//
//  EditSeriveViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/24/22.
//

import UIKit
import FirebaseStorage
import Firebase

class EditSeriveViewController: UIViewController {
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var txt_des: UITextField!
    @IBOutlet weak var txt_time: UITextField!
    @IBOutlet weak var img_edit: UIImageView!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBAction func btnDeleteService(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        showAlert()
    }
    var idSetEdit = ""
    var idEdit = ""
    var nameEdit = ""
    var priceEdit = 0
    var desEdit = ""
    var timeEdit = 0
    var imgEdit:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_name.text = nameEdit
        txt_price.text = String(priceEdit)
        txt_des.text = desEdit
        txt_time.text = String(timeEdit)
        img_edit.image = imgEdit
        idSetEdit = idEdit
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Admin", message: "Bạn thực sự muốn xóa dịch vụ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: { action in
            print("tapped Cancel")
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] action in
            self.ref.child("services/\(self.idSetEdit)").removeValue()
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
