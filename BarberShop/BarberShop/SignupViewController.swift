//
//  SignupViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/29/22.
//

import UIKit
import FirebaseStorage
import Firebase


class SignupViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var id_phone: IdPhone?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    var selectImage:UIImage?
    
    //btn
    @IBAction func btnOk(_ sender: Any) {
    }
    @IBAction func btnImage(_ sender: UITapGestureRecognizer) {
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
            image.image = selectImg
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("id phone is: \(String(describing: id_phone))")
    }
    
    func upLooadUser() {
        let storageRef = Storage.storage().reference()
        guard selectImage != nil else {
            return
        }
        let imageData = selectImage?.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        let strPath = "imgUser/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(strPath)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        // Upload that data
        var urlImage:String = ""
        let uploadTask = fileRef.putData(imageData!, metadata: metadata) {
            metadata, error in
            
            fileRef.downloadURL(completion: { [self] url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                UserDefaults.standard.set(urlString, forKey: "url")
                //Upload User
                
                let user = User(id: self.id_phone!.id, name: self.name.text!, phone: id_phone!.phone, image: urlString, role: 0)
                
                var ref: DatabaseReference!
                
                ref = Database.database().reference()
                guard let key = ref.child("users").childByAutoId().key else { return }
                ref.child("users/\(key)").setValue(["id": user.id,
                                                       "name": user.name,
                                                       "phone": user.phone,
                                                       "image": user.image,
                                                       "role": user.role])
            })
            
        }
        
    }
}
