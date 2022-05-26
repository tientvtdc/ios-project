//
//  HomeViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/24/22.
//

import UIKit
import FirebaseCore;
import FirebaseStorage;
import Firebase;
class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
    var storageRef:StorageReference!;
    var serviceList = [Service]();
    var ref: DatabaseReference!
    var isEnd = false;
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSlideMenu();
        FirebaseApp.configure();
        ref = Database.database().reference();
        storageRef = Storage.storage().reference();
        loadMore();
        // Do any additional setup after loading the view.
    }
    func setUpSlideMenu()  {
        let  menuBtn = UIBarButtonItem(image: UIImage(named: "hamburgerIcon"),  style: .plain , target: self.revealViewController() , action: #selector(SWRevealViewController.revealToggle(animated:)));
        
        self.navigationItem.setLeftBarButton(menuBtn, animated: true);
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! ServiceTableViewCell
        let service = self.serviceList[indexPath.row];
        
        cell.name.text = service.name;
        cell.price.text = "\(service.price) đ"
        cell.selectionStyle = .none
        
        let url = URL(string: service.image)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.profilePicImage.image = image
        }
        
        
        cell.backView.layer.cornerRadius = 8
        cell.backView.clipsToBounds = true
        
        cell.profilePicImage.layer.cornerRadius = 25
        cell.profilePicImage.clipsToBounds = true
        print(service.name)
        return cell
    }
    
    var serviceDetail:Service?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row;
        serviceDetail = serviceList[i];
        performSegue(withIdentifier: "ShowServiceDetail", sender: self)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let offsetY = scrollView.contentOffset.y
       let contentHeight = scrollView.contentSize.height

       if offsetY > contentHeight - scrollView.frame.size.height {
        if !isEnd {
            loadMore();
        }
           
       
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
    func loadMore() {
        var recentPostsQuery:DatabaseQuery;
        let lastKey  = serviceList.last?.id;
        if !self.serviceList.isEmpty {
            recentPostsQuery = (self.ref.child("services")).queryOrderedByKey().queryStarting(afterValue: lastKey).queryLimited(toFirst: 3);
        }else{
            recentPostsQuery = (self.ref.child("services")).queryLimited(toFirst: 3);
        }
        recentPostsQuery.observeSingleEvent(of: .value, with: {
            snapshot in for child in snapshot.children {
                let snap = child as! DataSnapshot
                let serviceDict = snap.value as! [String: Any]
                let name = serviceDict["name"] as! String
                let description = serviceDict["description"] as! String
                let image = serviceDict["image"] as! String
                let id = serviceDict["id"] as! String
                let price = serviceDict["price"] as! Double;
                var isContain = false;
                for service in self.serviceList {
                    if service.id == id {
                        isContain = true;
                        break;
                    }
                }
                if !isContain {
                    self.serviceList.append(Service(id: id, name: name, image: image, price: price, description: description, time: 1));
                }
                if snapshot.childrenCount < 3 {
                    self.isEnd = true;
                }
                

            }
            
            self.tableView.reloadData();
        })
//        recentPostsQuery.removeAllObservers();
    }

}
