//
//  EditSeriveViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/24/22.
//

import UIKit

class EditSeriveViewController: UIViewController {

    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var txt_des: UITextField!
    @IBOutlet weak var txt_time: UITextField!
    @IBOutlet weak var img_edit: UIImageView!
    
    var nameEdit = ""
    var priceEdit = 0
    var desEdit = ""
    var timeEdit = 0
    var imgEdit = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_name.text = nameEdit
        txt_price.text = String(priceEdit)
        txt_des.text = desEdit
        txt_time.text = String(timeEdit)
//        img_edit.text = imgEdit
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
