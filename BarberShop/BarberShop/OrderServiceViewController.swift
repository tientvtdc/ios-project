//
//  OrderServiceViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/26/22.
//

import UIKit
import Firebase
import FirebaseAuth
class OrderServiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var nameSevice: UILabel!
    
    @IBOutlet weak var timeForService: UILabel!
    @IBOutlet weak var priceService: UILabel!
    var dateOrder:Date?
    let arrTime = ["7:30","8:00","8:30","9:00","9:30","10:30","11:00","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00"]
    let arrNumberOrder = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    // Connect data:
    var service:Service!;
    var timeChoose:String?;
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrTime.count;
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeChoose = arrTime[row]
        //  print(timeChoose);
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel();
        label.text = arrTime[row];
        label.font = UIFont(name:"ArialRoundedMTBold", size: 30.0)
        label.textAlignment = .center;
        if arrNumberOrder[row] >= 10 {
            label.backgroundColor = .red;
        }else{
            if arrNumberOrder[row] >= 5 {
                label.backgroundColor = .yellow;
            }
        }
        
        return label;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        timeChoose = arrTime[0];
        datePicker.minimumDate = Date();
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 20, to: Date());
        dateOrder = Date();
        nameSevice.text = service.name;
        priceService.text =  NSNumber(value: service.price) .toVND();
        timeForService.text =   "\(service.time) phút";
    
    }
    
    
    @IBAction func changDate(_ sender: UIDatePicker) {

        dateOrder = sender.date;
    }
    
    
    @IBAction func orderServiceTap(_ sender: UIButton) {
        let splitArr = timeChoose?.split(separator: ":");
        
        self.dateOrder = Calendar.current.date(bySettingHour: Int(splitArr![0])!, minute: Int(splitArr![1])!, second: 0, of: self.dateOrder!)!
        var now  = Date();
        now.addTimeInterval(60*60);
        if dateOrder!.timeIntervalSince1970 <= now.timeIntervalSince1970 {
            let alert = UIAlertController(title: "Thông báo ", message: "Vui lòng đặt lịch trước 1 tiếng ", preferredStyle: .alert)
            let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
        
            }
            alert.addAction(ationOk);
            present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Thông báo ", message: "Bạn muốn đặt lịch ?", preferredStyle: .alert)
            let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
                self.addOrder();
                
            }
            let ationCancel = UIAlertAction(title: "Huỷ", style: .default) { (action) in
                
            }
            alert.addAction(ationOk);
            alert.addAction(ationCancel);
            present(alert, animated: true, completion: nil)
        }
 
        
    }
    func addOrder() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let key = ref.child("orders").childByAutoId().key else { return }
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { [self] snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            ref.child("orders/\(key)").setValue(["id":key,
                                                 "service":["id":self.service.id,
                                                            "name":self.service.name,
                                                            "price":self.service.price,
                                                            "image":self.service.image,
                                                            "description":self.service.description,
                                                            "time":self.service.time,
                                                            "create_at":String( self.service.create_at.timeIntervalSince1970)
                                                 ],
                                                 "customer":["id":Auth.auth().currentUser?.uid,
                                                             "name":name,
                                                             "phone":Auth.auth().currentUser?.phoneNumber
                                                 ],
                                                 "timeOrder": dateOrder!.timeIntervalSince1970,
                                                 "timeFinish":dateOrder!.timeIntervalSince1970,
                                                 "finish":0
            ]);
            let alert = UIAlertController(title: "Thông báo ", message: "Đặt lịch thành công", preferredStyle: .alert)
            let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil);
            }
            alert.addAction(ationOk);
            present(alert, animated: true, completion: nil)
           
        }) { error in
          print(error.localizedDescription)
        }

  
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
