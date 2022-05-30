//
//  ScheduleViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/29/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ScheduleViewController: UIViewController {
    
    @IBOutlet var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
        }
    }
    var databaseRef: DatabaseReference?
    var schedules = [Order]()
    var user: User = User()
    var service: Service = Service()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference().child("orders")
        databaseRef?.observe(.value, with: { snapshot in
            guard let values = snapshot.value as? [String: Any] else {return}
            
            for value in values {
                if let order = value.value as? [String: Any] {
                    //customer
                    if let customer = order["customer"] as? [String: Any] {
                        
                        //kiểm tra lich của khách hàng có trong danh firebase
                        //id client
                        let uid = Auth.auth().currentUser!.uid
                        //print("id: \(uid)")
                        if uid == customer["id"] as! String {
                            self.user = User(id: customer["id"] as! String
                                             , name: customer["name"] as! String
                                             , phone: customer["phone"] as! String
                                             , role: 1)
                            
                            //service
                            if let services = order["service"] as? [String: Any] {
                                self.service = Service(id: services["id"] as! String
                                                       , name: services["name"] as! String
                                                       , image: services["image"] as! String
                                                       , price: services["price"] as! Double
                                                       , description: services["description"] as! String
                                                       , time: services["time"] as! Int)
                            }
                            var id = order["id"]! as! String
                            
                            var timeOrder = order["timeOrder"]! as! Int64
                            var timeO: Date = Date(milliseconds: timeOrder)
                            
                            var timeFinish = order["timeFinish"]! as! Int64
                            var timeF: Date = Date(milliseconds: timeFinish)
                            
                            var isFinish = order["finish"]!
                            
                            
                            //schedule
                            var schedule = Order(id: id , service: self.service, customer: self.user, timeOrder: timeO, timeFinish: timeF, isFinish: isFinish as! Int)
                            
                            //print("schedule: \((schedule.customer?.name)!)")
                            
                            self.schedules.append(schedule)
                            let row = self.schedules.count
                            let indexPath = IndexPath(row: row-1, section: 0)
                            self.tblView.insertRows(at: [indexPath], with: .automatic)
                            
                            //print("s: \(self.schedules)")
                        }
                    }
                    
                }
            }
        })
        //update
        databaseRef?.observe(.childChanged, with: { (snapshot) -> Void in
            let index = self.indexOfMessage(snapshot)
            self.schedules[index].isFinish = snapshot.childSnapshot(forPath: "finish").value as? Int
            print("finish: \(self.schedules[index].isFinish)")
            self.tblView.reloadData()
        })
        
        
        
        
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    //cap nhat tai vi tri
    func indexOfMessage(_ snapshot: DataSnapshot) -> Int {
        var index = 0
        for comment in schedules {
            if snapshot.key == comment.id {
                return index
            }
            index += 1
        }
        return -1
    }
    
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(self.schedules.count)")
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let schedule = self.schedules[indexPath.row]
        print("s: \(schedule)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as? ScheduleTableViewCell {
            
            let url = URL(string: schedule.service!.image)!
            do {
                let dulieu:Data = try Data(contentsOf: url)
                cell.imgSchedule.image = UIImage(data: dulieu)
            }
            catch {
                print("Get image failed")
            }
            
            cell.nameSchedule.text = schedule.service?.name
            cell.dateSchedule.text = schedule.timeOrder?.description
            cell.priceSchedule.text = String((schedule.service?.price)!)
            
            return cell
        }
        
        //print("s: \(schedules)")
        
        fatalError("can not create the cell");
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailSch = storyboard?.instantiateViewController(withIdentifier: "ScheduleDetailController") as? ScheduleDetailController {
            self.navigationController?.pushViewController(detailSch, animated: true)
            let sch = schedules[indexPath.row]
            let url:URL = URL(string: sch.service!.image)!
            do {
                let dulieu:Data = try Data(contentsOf: url)
                detailSch.imgSch = UIImage(data: dulieu)!
            }
            catch {
                print("Get image failed")
            }
            detailSch.nameSch = sch.service!.name
            detailSch.dateSch = sch.timeOrder!
            detailSch.priceSch = sch.service!.price
            detailSch.desSch = sch.service!.description
            detailSch.id = sch.id!
        }
    }
    
}

//thong bao
//let alert = UIAlertController(title: "Barber Shop", message: "Bạn chưa có lịch cắt tóc nào !", preferredStyle: .alert)
//let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
//}
//alert.addAction(ationOk);
//self.present(alert, animated: true, completion: nil);
