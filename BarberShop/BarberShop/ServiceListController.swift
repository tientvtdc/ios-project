//
//  ServiceListController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/22/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class ServiceListController: UIViewController {
    @IBOutlet var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
        }
    }
    
    var databaseRef: DatabaseReference?
    
    var data = [ServiceBarberShop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isConfig {
            FirebaseApp.configure()
            isConfig = true
        }
        databaseRef = Database.database().reference().child("services")
        databaseRef?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let id  = value["id"] as? String,
                let name  = value["name"] as? String,
                let image = value["image"] as? String,
                let des = value["description"] as? String,
                let price = value["price"] as? Int {
                let sv = ServiceBarberShop(id: id, name: name, price: price, des: des, time: 10, image: image)
                self?.data.append(sv);
                if let row = self?.data.count {
                    let indexPath = IndexPath(row: row-1, section: 0)
                    self?.tblView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
        // Listen for deleted comments in the Firebase database
        databaseRef?.observe(.childRemoved, with: { (snapshot) -> Void in
            let index = self.indexOfMessage(snapshot)
          self.data.remove(at: index)
          self.tblView.deleteRows(
            at: [IndexPath(row: index, section: 0)],
            with: UITableView.RowAnimation.automatic
          )
        })
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    func indexOfMessage(_ snapshot: DataSnapshot) -> Int {
       var index = 0
       for comment in data {
           if snapshot.key == comment.id {
           return index
         }
         index += 1
       }
       return -1
     }

}

extension ServiceListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceItem = data[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ServiceTableViewCell {
            let url:URL = URL(string: serviceItem.image)!
            do {
                let dulieu:Data = try Data(contentsOf: url)
                cell.imgService.image = UIImage(data: dulieu)
            }
            catch {
                print("Get image failed")
            }
            cell.nameService.text = serviceItem.name
            cell.priceService.text = String(serviceItem.price)
        return cell
        }
        fatalError("can not create the cell");
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let edit = storyboard?.instantiateViewController(withIdentifier: "EditServiceViewController") as? EditSeriveViewController {
            self.navigationController?.pushViewController(edit, animated: true)
            let serviceItem = data[indexPath.row]
            edit.idEdit = serviceItem.id
            edit.nameEdit = serviceItem.name
            edit.priceEdit = serviceItem.price
            edit.desEdit = serviceItem.des
            edit.timeEdit = serviceItem.time
            let url:URL = URL(string: serviceItem.image)!
            do {
                let dulieu:Data = try Data(contentsOf: url)
                edit.imgEdit = UIImage(data: dulieu)
            }
            catch {
                print("Get image failed")
            }
        }
    }
}
