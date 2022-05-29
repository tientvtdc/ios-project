//
//  VerifyCodeLoginViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/25/22.
//

import UIKit
import FirebaseAuth
import Firebase

class VerifyCodeLoginViewController: UIViewController {
    var phone = "";
    var verificationID = "";
    @IBOutlet weak var textFieldCodeAuth: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().languageCode = "vi";
print(phone)
        PhoneAuthProvider.provider()
          .verifyPhoneNumber("+84"+phone, uiDelegate: nil) { verificationID, error in
              if let error = error {
//                self.showMessagePrompt(error.localizedDescription)
                print(error.localizedDescription);
                return
              }
            self.verificationID = verificationID!;
              // Sign in using the verificationID and the code sent to the user
              // ...
          }
    }
    @IBAction func verifycodeBtn(_ sender: Any) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        if let verificationCode = textFieldCodeAuth.text{
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: self.verificationID,
                verificationCode: verificationCode);
         //   Auth.auth().
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                let alert = UIAlertController(title: "Lỗi", message: "Mã xác nhận không đúng ", preferredStyle: .alert)
                let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(ationOk);
                    self.textFieldCodeAuth.text = "" ;
                self.present(alert, animated: true, completion: nil);
                    return
              }
                // check user exist4
                if let uid = authResult?.user.uid {
                    var ref: DatabaseReference!
                    ref = Database.database().reference();
                    ref.child("user").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                      // Get user value
                        if let value = snapshot.value as? NSDictionary {
                            //goto home
                            //print("ok go to home")
                            //self.performSegue(withIdentifier: "goToHomeFromVerifyCode", sender: nil);
                            //goto signup
                            if let id_phone = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
                                self.navigationController?.pushViewController(id_phone, animated: true)
                                id_phone.id = self.verificationID
                                id_phone.phone = self.phone
                            }
                        }
                        else {
                            //goto signup
                            if let id_phone = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
                                self.navigationController?.pushViewController(id_phone, animated: true)
                                id_phone.id = self.verificationID
                                id_phone.phone = self.phone
                            }
                        }
                    }) { error in
                      print(error.localizedDescription)
                    }
                }
              // User is signed in
              // ...
//                self.performSegue(withIdentifier: "goToHomeFromVerifyCode", sender: nil);
//                if let uid = authResult?.user.uid {
//                    var ref: DatabaseReference!
//                    ref = Database.database().reference();
//                    ref.child("user").child(uid).observeSingleEvent(of: .value, with: { snapshot in
//                      // Get user value
//                      let value = snapshot.value as? NSDictionary
//   //                   let username = value?["username"] as? String ?? ""
////                      let user = User(username: username)
//                        print(value);
//                        print(uid);
//
//                      // ...
//                    }) { error in
//                      print(error.localizedDescription)
//                    }
//                }
              
            }

        }
    
    }
    

    @IBAction func backLoginSreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
