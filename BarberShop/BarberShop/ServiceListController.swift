//
//  ServiceListController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/22/22.
//

import UIKit

class ServiceListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: properties
//    struct ServiceBarberShop {
//        let name: String
//        let price: Int
//        let des: String
//        let time: Int
//        let image: UIImage?
//    }
    let data: [ServiceBarberShop] = [
        ServiceBarberShop(id: "1",name: "dich vu 1", price: 12500, des: "Xoa bop", time: 15, image: "none"),
        ServiceBarberShop(id: "2",name: "dich vu 1", price: 22500, des: "Xoa bop", time: 15, image: "none"),
        ServiceBarberShop(id: "3",name: "dich vu 1", price: 13800, des: "Xoa bop", time: 15, image: "none")
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceItem = data[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ServiceTableViewCell {
//            cell.imgService.image = serviceItem.image
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
            edit.nameEdit = serviceItem.name
            edit.priceEdit = serviceItem.price
            edit.desEdit = serviceItem.des
            edit.timeEdit = serviceItem.time
            edit.imgEdit = "none"
            
        }
    }

    
    @IBOutlet var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
    }

}
