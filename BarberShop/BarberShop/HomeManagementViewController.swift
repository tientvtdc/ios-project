//
//  HomeManagementViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/28/22.
//

import UIKit
import FirebaseAuth
class HomeManagementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goToHomeCustomer(_ sender: Any) {
        dismiss(animated: false, completion: nil);
    }
    @IBAction func logout(_ sender: UIButton) {
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
}
