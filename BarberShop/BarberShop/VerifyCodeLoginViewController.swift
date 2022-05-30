//
//  VerifyCodeLoginViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/25/22.
//

import UIKit
import FirebaseAuth
import Firebase

struct IdPhone {
    let id:String
    let phone:String
}

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
                            print("ok go to home")
                            self.performSegue(withIdentifier: "goToHomeFromVerifyCode", sender: nil);
                            
                        }
                        else {
                            //goto signup
                            
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //create a new variable that yo;u want to send
        var newIdPhone = IdPhone(id: verificationID, phone: phone)
        
        //create a new variable to store the instance of
        if let sendIdPhone = segue.destination as? SignupViewController {
            sendIdPhone.id_phone = newIdPhone
        }
    }

}
