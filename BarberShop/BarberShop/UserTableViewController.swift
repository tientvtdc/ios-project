//
//  UserTableViewController.swift
//  BarberShop
//
//  Created by Thanh Tuan Hang on 5/26/22.
//

import UIKit
import FirebaseCore;
import FirebaseStorage;
import Firebase;
import SDWebImage

class UserTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var userData:User?
    private var segueUser = "SegueUser"
    private var userList = [User]();
    var ref: DatabaseReference!
    var isEnd = false;
    var storageRef:StorageReference!;
    
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 3.0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference();
        storageRef = Storage.storage().reference();
        beginBatchFetch();
       
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        //        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade);
        fetchPosts { newPosts in
            self.userList.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchPosts(completion:@escaping (_ userList:[User])->()) {
        let postsRef = Database.database().reference().child("users")
        var queryRef:DatabaseQuery
        let lastPost = userList.last;
        if lastPost != nil {
            queryRef = postsRef.queryOrderedByKey().queryEnding(atValue: lastPost!.id).queryLimited(toLast: 2);

        } else {
            queryRef = postsRef.queryLimited(toLast: 2);
        }
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [User]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let serviceDict = childSnapshot.value as? [String:Any],
                   let name = serviceDict["name"] as? String,
                   let phone = serviceDict["phone"] as? String ,
                   let image = serviceDict["image"] as? String,
                   let role = serviceDict["role"] as? Int,
                   let id = serviceDict["id"] as? String {
                    if childSnapshot.key != lastPost?.id {
                        let sv =  User(id: id, name: name, phone: phone, image: image, role: role)
                        tempPosts.append(sv);
                    }
                    
                }
            }
            
            return completion(tempPosts)
        })
    }
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as! CustomUserTableViewCell
        
        let user = self.userList[indexPath.row]
        self.userData = self.userList[indexPath.row]
        cell.userName.text = user.name;
        
        let url = URL(string: user.image);
        cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_pic"));
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height / 2
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create an instance of PlayerTableViewController and pass the variable
            let destinationVC = UserDetailViewController()
            destinationVC.user = userData

            // Let's assume that the segue name is called playerSegue
            // This will perform the segue and pre-load the variable for you to use
        destinationVC.performSegue(withIdentifier: "playerSegue", sender: self)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueUser{
                // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! UserDetailViewController
                destinationVC.user = userData
        }
    }
    
    
}
