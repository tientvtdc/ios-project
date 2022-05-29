//
//  ScheduleTableViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/29/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftUI

class ScheduleTableViewController: UITableViewController {
    
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
                        self.user = User(id: customer["id"] as! String
                                        , name: customer["name"] as! String
                                        , phone: customer["phone"] as! String
                                        , role: 1)
                        
                    }
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
                    
                    var isFinish = order["isFinish"]!
                    
                    
                    //schedule
                    var schedule = Order(id: id , service: self.service, customer: self.user, timeOrder: timeO, timeFinish: timeF, isFinish: isFinish as! Int)
                    
                    //print("schedule: \((schedule.customer?.name)!)")
                    
                    self.schedules.append(schedule);
                    print("s: \(self.schedules)")
                    
                
                    
                }
            }
            
        })
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("count: \(self.schedules.count)")
        return self.schedules.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let schedule = self.schedules[indexPath.row]
        print("s: \(schedule)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as? ScheduleTableViewCell {
            
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/barber-shop-group-1.appspot.com/o/imgUser%2F1652948056869?alt=media&token=8b1fc102-811d-49ed-a5ec-04eb47064a1d")!
            do {
                let dulieu:Data = try Data(contentsOf: url)
                cell.imgSchedule.image = UIImage(data: dulieu)
            }
            catch {
                print("Get image failed")
            }
            
//            cell.nameSchedule.text = schedule.service?.name
//            cell.dateSchedule.text = schedule.timeOrder?.description
//            cell.priceSchedule.text = String((schedule.service?.price)!)
            cell.nameSchedule.text = "bao"
            cell.dateSchedule.text = "bao"
            cell.priceSchedule.text = "bao"
            
            
            return cell
        }

        print("s: \(schedules)")
        
        fatalError("can not create the cell");
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
