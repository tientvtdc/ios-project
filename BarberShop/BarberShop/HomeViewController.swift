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
import SDWebImage

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
    var storageRef:StorageReference!;
    var serviceList = [Service]();
    var ref: DatabaseReference!
    var isEnd = false;
    
    var fetchingMore = false
       var endReached = false
       let leadingScreensForBatching:CGFloat = 3.0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSlideMenu();
        ref = Database.database().reference();
        storageRef = Storage.storage().reference();
        beginBatchFetch();
        // Do any additional setup after loading the view.
    }
    func setUpSlideMenu()  {
        let  menuBtn = UIBarButtonItem(image: UIImage(named: "hamburgerIcon"),  style: .plain , target: self.revealViewController() , action: #selector(SWRevealViewController.revealToggle(animated:)));
        
        self.navigationItem.setLeftBarButton(menuBtn, animated: true);
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         switch section {
         case 0:
             return serviceList.count
         case 1:
             return fetchingMore ? 1 : 0
         default:
             return 0
         }
     }
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! ServiceTableViewCell
        let service = self.serviceList[indexPath.row];
        
        cell.name.text = service.name;
        cell.price.text = NSNumber(value: service.price) .toVND()
//        cell.selectionStyle = .none
        
        let url = URL(string: service.image);
        cell.profilePicImage.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_pic"));
        cell.timeForService.text = "\(service.time) phút"
        cell.backView.layer.cornerRadius = 15
        cell.backView.clipsToBounds = true
//        cell.layer.borderWidth = 2;
        
//        cell.profilePicImage.layer.cornerRadius = 25
//        cell.profilePicImage.clipsToBounds = true
        //print(service.name)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
            if segue.identifier == "ShowServiceDetail" {
                if   let navigationController = segue.destination as? UINavigationController{
                    if let vcDeTai = navigationController.viewControllers.first as? DetailServiceViewController{
                        vcDeTai.service = serviceDetail;
                    }
                }
                
            }
        
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
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
//        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade);
        fetchPosts { newPosts in
            self.serviceList.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchPosts(completion:@escaping (_ serviceList:[Service])->()) {
        let postsRef = Database.database().reference().child("services")
        var queryRef:DatabaseQuery
        let lastPost = serviceList.last;
        if lastPost != nil {
            queryRef = postsRef.queryOrderedByKey().queryEnding(atValue: lastPost!.id).queryLimited(toLast: 2);
        } else {
            queryRef = postsRef.queryLimited(toLast: 2);
        }
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Service]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let serviceDict = childSnapshot.value as? [String:Any],
                    let name = serviceDict["name"] as? String,
                    let description = serviceDict["description"] as? String ,
                    let image = serviceDict["image"] as? String,
                    let price = serviceDict["price"] as? Double,
                    let id = serviceDict["id"] as? String {
                    if childSnapshot.key != lastPost?.id {
                      let sv =  Service(id: id, name: name, image: image, price: price, description: description, time: 1)
                        tempPosts.append(sv);
                    }
                    
                }
            }
            
            return completion(tempPosts)
        })
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
