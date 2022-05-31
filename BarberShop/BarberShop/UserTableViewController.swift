//
//  UserTableViewController.swift
//  BarberShop
//
//  Created by Thanh Tuan Hang on 5/26/22.
//

import UIKit
import FirebaseCore;
import FirebaseStorage;
import FirebaseDatabase
import Firebase;
import SDWebImage

class UserTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    // MARK: Fields
    var users = [User]()
    var userData:User?
    var	ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Initiation
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference();
        let userID = Auth.auth().currentUser?.uid;
        ref!.child("users").child(userID!).observeSingleEvent(of: .value, with: { [self] snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
            let role = value?["role"] as? Int ;
            if role != 2 {
                let alert = UIAlertController(title: "Thông báo ", message: "Chức năng dành cho quản trị viên", preferredStyle: .alert)
                let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
                        dismiss(animated: true, completion: nil)
                    }
       
                alert.addAction(ationOk);
                present(alert, animated: true, completion: nil)
            }
        }) { error in
          print(error.localizedDescription)
        }
        fetchUser()
    }
    
    // MARK: Create User list
    func fetchUser() {
        self.ref!.child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.users.append(user)
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    // MARK: Set the number of column
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // MARK: Set height for each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: Set each cell's data
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as! CustomUserTableViewCell
        let user = self.users[indexPath.row]
        self.userData = self.users[indexPath.row]
        cell.userName.text = user.name;
        let url = URL(string: user.image!);
        cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_pic"));
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height / 2
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        return cell
    }
    
    // MARK: Set selected row event listener
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userData = users[indexPath.row];
        self.performSegue(withIdentifier: "segueUserDetail", sender: self)
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! UserDetailViewController
        if let moveUser = userData{
            receiverVC.user = moveUser
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Set event when back to this monitor
    @IBAction func unwindToUserTableViewControlelr(_ unwindSegue: UIStoryboardSegue) {
        self.users.removeAll()
        fetchUser()
    }
}
