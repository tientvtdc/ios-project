//
//  HamburgerViewController.swift
//  HamburgerMenu
//
//  Created by Kashyap on 13/11/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
protocol HamburgerViewControllerDelegate {
    func hideHamburgerMenu()
}
class HamburgerViewController: UIViewController {

    @IBOutlet weak var btnGotoHomeManagement: UIButton!
    var delegate : HamburgerViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHamburgerUI()
        // Do any additional setup after loading the view.
        
    }
    
    private func setupHamburgerUI()
    {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid;
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { [self] snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
            let role = value?["role"] as? Int ;
            if role != 0 {
                btnGotoHomeManagement.isHidden = false;
            }
        }) { error in
          print(error.localizedDescription)
        }
    }
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        let alert = UIAlertController(title: "Thông báo ", message: "Bạn muốn đăng xuất ?", preferredStyle: .alert)
        let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
            do {
                try firebaseAuth.signOut();
//                self.performSegue(withIdentifier: "goToLoginFromHomeScreen", sender: nil);
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil);
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
              
            }
        let ationCancel = UIAlertAction(title: "Huỷ", style: .default) { (action) in
              
            }
        alert.addAction(ationOk);
        alert.addAction(ationCancel);
        present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
