//
//  LoginViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/23/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController {

    @IBOutlet weak var edtPhone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil  {
               self.performSegue(withIdentifier: "goToHomeFromLoginScreen", sender: nil);
           }
    }
    @IBAction func unwindToLoginVC(_ unwindSegue: UIStoryboardSegue) {
           if let vcB = unwindSegue.source as? VerifyCodeLoginViewController {
            if vcB.isSuccessLogin{
                if Auth.auth().currentUser != nil  {
                       self.performSegue(withIdentifier: "goToHomeFromLoginScreen", sender: nil);
                   }
            }
           }
       }
    @IBAction func clickLogin(_ sender: Any) {
        if edtPhone.text?.count != 10 {
            let alert = UIAlertController(title: "Lỗi", message: "Số điện thoại không hợp lệ", preferredStyle: .alert)
            let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(ationOk);
            present(alert, animated: true, completion: nil);
        }else{
            performSegue(withIdentifier: "goToVertifyCode", sender: self);
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVertifyCode" {
            if   let verifyCodeLoginViewController = segue.destination as? VerifyCodeLoginViewController{
                verifyCodeLoginViewController.phone = edtPhone.text!
                edtPhone.text = "";
            }
            
        }else{
            if segue.identifier == "goToHomeFromLoginScreen" {
//                
            }
        }
    }
    
}
