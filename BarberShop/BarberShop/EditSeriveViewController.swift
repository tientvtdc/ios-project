//
//  EditSeriveViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/24/22.
//

import UIKit
import FirebaseStorage
import Firebase

class EditSeriveViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var txt_des: UITextField!
    @IBOutlet weak var txt_time: UITextField!
    @IBOutlet weak var img_edit: UIImageView!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var idSetEdit = ""
    var idEdit = ""
    var nameEdit = ""
    var priceEdit = 0
    var desEdit = ""
    var timeEdit = 0
    var imgEdit:UIImage?
    var selectImage:UIImage?
    var imgOld = ""
    var imgSetOld = ""
    var createAtOld:Date?
    var createAtSetOld:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_name.text = nameEdit
        txt_price.text = String(priceEdit)
        txt_des.text = desEdit
        txt_time.text = String(timeEdit)
        img_edit.image = imgEdit
        idSetEdit = idEdit
        imgSetOld = imgOld
        createAtSetOld = createAtOld
    }
    
    @IBAction func imgProcessing(_ sender: UITapGestureRecognizer) {
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
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // Update Service
    @IBAction func btnUpdateService(_ sender: Any) {
        uploadService()
        self.navigationController?.popViewController(animated: true)
    }
    
    func uploadService() {
        //Create storage
        let storageRef = Storage.storage().reference()
        guard selectImage != nil else {
            var refs: DatabaseReference!
            
            refs = Database.database().reference()
            
            refs.child("services/\(self.idSetEdit)").setValue(["id":self.idSetEdit,
                                                               "name":self.txt_name.text!,
                                                                   "price":Int(self.txt_price.text!)!,
                                                                   "image":imgSetOld,
                                                               "description":self.txt_des.text!,
                                                               "time":Int(self.txt_time.text!)!,
                                                               "create_at":String(self.createAtSetOld!.timeIntervalSince1970)
                                                             ])
            return
        }

        let imageData = selectImage?.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        let strPath = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(strPath)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        // Upload that data
        var urlImage:String = ""
        let uploadTask = fileRef.putData(imageData!, metadata: metadata) {
            metadata, error in

            fileRef.downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                urlImage = "\(urlString)"
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
                //Upload Service
                let idNewService = UUID().uuidString;
                let priceCV: Int? = Int(self.txt_price.text!)
                let timeCV: Int? = Int(self.txt_time.text!)
                let newAddService:Service = Service(id: idNewService, name: self.txt_name.text!, image: urlImage, price: Double(priceCV!), description: self.txt_des.text!, time: timeCV!)
                
                var ref: DatabaseReference!
                
                ref = Database.database().reference()
                
                ref.child("services/\(self.idSetEdit)").setValue(["id":self.idSetEdit,
                                                                       "name":newAddService.name,
                                                                       "price":priceCV!,
                                                                       "image":newAddService.image,
                                                                       "description":newAddService.description,
                                                                  "time":newAddService.time,
                                                                  "create_at":String(self.createAtSetOld!.timeIntervalSince1970)
                                                                 ])
            })
        }
    }
    
    // Delete Service with dialog
    
    @IBAction func btnDeleteService(_ sender: Any) {
        showAlert()
    }
    func showAlert() {
        let alert = UIAlertController(title: "Admin", message: "Bạn thực sự muốn xóa dịch vụ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: { action in
            print("tapped Cancel")
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] action in
            self.ref.child("services/\(self.idSetEdit)").removeValue()
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
