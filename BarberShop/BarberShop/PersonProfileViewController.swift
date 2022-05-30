//
//  PersonProfileViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/29/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class PersonProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    var imgEdit:UIImage?
    var selectImage:UIImage?
    var ref: DatabaseReference!
    var isEditImage = false;
    var user: User?
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var img_edit: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSlideMenu();
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        img_edit.isUserInteractionEnabled = true
        img_edit.addGestureRecognizer(tapGestureRecognizer)
        img_edit.layer.borderWidth = 1
        img_edit.layer.masksToBounds = false
        img_edit.layer.borderColor = UIColor.black.cgColor
        img_edit.layer.cornerRadius = img_edit.frame.height/2
        img_edit.clipsToBounds = true
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { [self] snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            nameLabel.text = name;
            if   let url = value?["image"] as? String{
                img_edit.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "profile_pic"));
                //                self.user  User(userID,  name,  Auth.auth().currentUser?.phoneNumber,  url);
                if let phone  = Auth.auth().currentUser?.phoneNumber {
                    user = User(id: userID!, name: name, phone: phone, image: url);
                }
                
            }
            if let phone  = Auth.auth().currentUser?.phoneNumber {
                phoneLabel.text = phone ;
                
            }
            
            
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
    func setUpSlideMenu()  {
        let  menuBtn = UIBarButtonItem(image: UIImage(named: "hamburgerIcon"),  style: .plain , target: self.revealViewController() , action: #selector(SWRevealViewController.revealToggle(animated:)));
        
        self.navigationItem.setLeftBarButton(menuBtn, animated: true);
        
    }
    @IBAction func update(_ sender: Any) {
        //Create storage
        if !isEditImage {
            let name = nameLabel.text;
            let id = Auth.auth().currentUser!.uid;
            self.ref.child("users/\(id)").child("name").setValue(name);
            let alert = UIAlertController(title: "Thông báo ", message: "Cập nhật thành công ", preferredStyle: .alert)
            let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(ationOk);
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
            let imageData = selectImage?.jpegData(compressionQuality: 0.8);
            guard imageData != nil else {
                return
            }
            let storageRef = Storage.storage().reference()
            let strPath = "imgUser/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(strPath);
            let id = Auth.auth().currentUser!.uid;
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            // Upload that data
            let uploadTask = fileRef.putData(imageData!, metadata: metadata) {
                metadata, error in

                fileRef.downloadURL(completion: { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    let urlString = url.absoluteString;
                    UserDefaults.standard.set(urlString, forKey: "url")
                    //Upload Service
                    let name = self.nameLabel.text;
                    self.ref.child("users/\(id)").child("name").setValue(name);
                    self.ref.child("users/\(id)").child("image").setValue(urlString);
                    
                    let alert = UIAlertController(title: "Thông báo ", message: "Cập nhật thành công ", preferredStyle: .alert)
                    let ationOk = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
                    alert.addAction(ationOk);
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
        
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // let tappedImage = tapGestureRecognizer.view as! UIImageView
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImg = info[.originalImage] as? UIImage
        {
            selectImage = selectImg
            img_edit.image = selectImg
            isEditImage = true;
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
