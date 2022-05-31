//
//  OrderListManagementViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/29/22.
//

import UIKit
import FirebaseCore;
import FirebaseStorage;
import Firebase;
import SDWebImage
class OrderListManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var storageRef:StorageReference!;
    var orderList = [Order]();
    var ref: DatabaseReference!
    var isEnd = false;
    
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 3.0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference();
        storageRef = Storage.storage().reference();
        beginBatchFetch();
        // Do any additional setup after loading the view.
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orderList.count
        case 1:
            return fetchingMore ? 1 : 0
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : OrderManagementTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderManagementTableViewCell", for: indexPath) as! OrderManagementTableViewCell
        let order = self.orderList[indexPath.row];
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "HH:mm dd/MM/YY"
        
        // Convert Date to String
        
        
        let url = URL(string: order.service!.image);
        cell.imgService.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_pic"));
        cell.imgService.clipsToBounds = true
        cell.dateOrder.text = dateFormatter.string(from: order.timeOrder!);
        cell.phone.text = order.customer?.phone;
        cell.nameService.text = order.service?.name;
        if order.finish == 0 {
            cell.finish.text = "Chưa Hoàn Thành"
            cell.finish.textColor = .gray;
        }else{
            if order.finish == 1 {
                cell.finish.text = "Hoàn Thành"
                cell.finish.textColor = .green;
            }
            else{
                cell.finish.text = "Đã huỷ"
                cell.finish.textColor = .red;
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowOrderManagementDetail" {
            if   let navigationController = segue.destination as? UINavigationController{
                if let vcDeTai = navigationController.viewControllers.first as? DetailOrderManagementViewController{
                    vcDeTai.orserDetail = detailOrder;
                }
            }
        }
        
    }
    var detailOrder:Order?;
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row;
        detailOrder = orderList[i];
        performSegue(withIdentifier: "ShowOrderManagementDetail", sender: self)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func beginBatchFetch() {
        fetchingMore = true
        //        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade);
        fetchPosts { newPosts in
            
            self.orderList.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchPosts(completion:@escaping (_ orderList:[Order])->()) {
        let postsRef = Database.database().reference().child("orders")
        var queryRef:DatabaseQuery
        let lastPost = orderList.last;
        if lastPost != nil {
            queryRef = postsRef.queryOrderedByKey().queryEnding(atValue: lastPost!.id).queryLimited(toLast: 9);
        } else {
            queryRef = postsRef.queryLimited(toLast:  9);
        }
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Order]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let orderDict = childSnapshot.value as? [String:Any],
                   let serviceDict = orderDict["service"] as? [String:Any],
                   let name =  serviceDict["name"] as? String,
                   let description = serviceDict["description"] as? String ,
                   let image = serviceDict["image"] as? String,
                   let price = serviceDict["price"] as? Double,
                   let time = serviceDict["time"] as? Int,
                   let id = serviceDict["id"] as? String {
                    print(id)
                    if childSnapshot.key != lastPost?.id && childSnapshot.key != self.orderList.first?.id{
                        let sv =  Service(id: id, name: name, image: image, price: price, description: description, time: time)
                        if let finish = orderDict["finish"] as? Int,
                           let timeOrder = orderDict["timeOrder"] as? Int,
                           let timeFinish = orderDict["timeFinish"] as? Int,
                           let customer = orderDict["customer"] as? [String:Any]
                        {
                            let idOrder = childSnapshot.key;
                            //                            var isContain = false;
                            //                            for orderIn in self.orderList {
                            //                                if idOrder == orderIn.id {
                            //                                    isContain = true;
                            //                                }
                            //                            }
                            //                            if !isContain {
                            let nameCustomer = customer["name"] as! String;
                            let phoneCustomer = customer["phone"] as! String;
                            tempPosts.append(Order(id: idOrder,service: sv, timeOrder: Date(timeIntervalSince1970: TimeInterval(timeOrder)), timeFinish: Date(timeIntervalSince1970: TimeInterval(timeFinish)) , finish: finish,  customer: User(id: "", name: nameCustomer, phone: phoneCustomer, image: "")));
                            // }
                        }
                        
                    }
                    
                }
            }
            
            return completion(tempPosts.reversed())
        })
    }
    // MARK: Set event when back to this monitor
    @IBAction func unwindToUserTableViewControlelr(_ unwindSegue: UIStoryboardSegue) {
        self.orderList.removeAll();
        fetchingMore = false
        endReached = false
        beginBatchFetch();
    }
}
