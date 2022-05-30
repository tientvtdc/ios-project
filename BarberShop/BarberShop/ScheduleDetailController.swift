//
//  ScheduleDetailController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/29/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class ScheduleDetailController: UIViewController {

    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var img_sch: UIImageView!
    @IBOutlet weak var lbl_name_sch: UILabel!
    @IBOutlet weak var lbl_date_sch: UILabel!
    @IBOutlet weak var lbl_price_sch: UILabel!
    @IBOutlet weak var lbl_des_sch: UILabel!
    
    //button
    @IBAction func btnCancel(_ sender: Any) {
        showAlert()
    }
    @IBAction func btnChange(_ sender: Any) {
        
    }
    
    var id: String = ""
    var imgSch:UIImage?
    var nameSch = ""
    var dateSch = Date.init()
    var priceSch = 0.0
    var desSch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        img_sch.image = imgSch
        lbl_name_sch.text = nameSch
        lbl_date_sch.text = dateSch.description
        lbl_price_sch.text = String(priceSch)
        lbl_des_sch.text = desSch
        
        print("id: \(id)")
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showAlert() {
        let alert = UIAlertController(title: "Barber Shop", message: "Bạn thực sự muốn hủy dịch vụ ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: { action in
            print("tapped Cancel")
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] action in
            self.ref.child("orders/\(self.id)/finish").setValue(3)
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

}
