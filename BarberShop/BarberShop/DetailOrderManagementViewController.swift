//
//  DetailOrderManagementViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/30/22.
//

import UIKit
import FirebaseDatabase
class DetailOrderManagementViewController: UIViewController {
    
    @IBOutlet weak var nameCustomer: UILabel!
    @IBOutlet weak var phoneCustomer: UILabel!
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var timeOrder: UILabel!
    @IBOutlet weak var finishOrder: UILabel!
    
    @IBOutlet weak var clBtn: UIButton!
    @IBOutlet weak var fnBtn: UIButton!
    var orserDetail:Order?
    override func viewDidLoad() {
        super.viewDidLoad()

        if orserDetail!.finish != 0 {
            clBtn.isHidden = true;
            fnBtn.isHidden = true;
        }
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "HH:mm dd/MM/YY"

        nameCustomer.text = orserDetail?.customer?.name
        phoneCustomer.text = orserDetail?.customer?.phone
        nameService.text = orserDetail?.service?.name;
        timeOrder.text = dateFormatter.string(from: orserDetail!.timeOrder!);
        if orserDetail!.finish == 0 {
            finishOrder.text = "Chưa Hoàn Thành"
            finishOrder.textColor = .gray;
        }else{
            if orserDetail!.finish == 1 {
                finishOrder.text = "Hoàn Thành"
                finishOrder.textColor = .green;
            }
            else{
                finishOrder.text = "Đã huỷ"
                finishOrder.textColor = .red;
            }
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Thông báo ", message: "Bạn muốn hoàn thành lịch hẹn ?", preferredStyle: .alert)
        let ationOk = UIAlertAction(title: "OK", style: .default) { [self] (action) in
            var ref: DatabaseReference!
            ref = Database.database().reference();
            ref.child("orders").child((orserDetail?.id)!).child("finish").setValue(1);
            clBtn.isHidden = true;
            fnBtn.isHidden = true;
            finishOrder.text = "Hoàn Thành"
            finishOrder.textColor = .green;
            }
        let ationCancel = UIAlertAction(title: "Huỷ", style: .default) { (action) in
              
            }
        alert.addAction(ationOk);
        alert.addAction(ationCancel);
        present(alert, animated: true, completion: nil)
    }
    @IBAction func Cancle(_ sender: Any) {
        let alert = UIAlertController(title: "Thông báo ", message: "Bạn muốn huỷ lịch hẹn ?", preferredStyle: .alert)
        let ationOk = UIAlertAction(title: "OK", style: .default) { [self] (action) in
            var ref: DatabaseReference!
            ref = Database.database().reference();
            ref.child("orders").child((orserDetail?.id)!).child("finish").setValue(2);
            clBtn.isHidden = true;
            fnBtn.isHidden = true;
            finishOrder.text = "Đã huỷ"
            finishOrder.textColor = .red;
            }
        let ationCancel = UIAlertAction(title: "Không", style: .default) { (action) in
              
            }
        alert.addAction(ationOk);
        alert.addAction(ationCancel);
        present(alert, animated: true, completion: nil)
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
