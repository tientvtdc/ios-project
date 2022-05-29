//
//  HamburgerViewController.swift
//  HamburgerMenu
//
//  Created by Kashyap on 13/11/20.
//

import UIKit
import FirebaseAuth
protocol HamburgerViewControllerDelegate {
    func hideHamburgerMenu()
}
class HamburgerViewController: UIViewController {

    var delegate : HamburgerViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHamburgerUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupHamburgerUI()
    {
   
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
