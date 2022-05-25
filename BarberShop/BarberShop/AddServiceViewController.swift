//
//  AddServiceViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/21/22.
//

import UIKit
import FirebaseStorage
import Firebase

var isConfig:Bool = false
class AddServiceViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var nameAddService: UITextField!
    @IBOutlet weak var priceAddService: UITextField!
    @IBOutlet weak var desAddServive: UITextField!
    @IBOutlet weak var timeAddService: UITextField!
    var selectImage:UIImage?
    
    @IBOutlet weak var imgAddNewService: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAddNewService.layer.cornerRadius = 5
        if !isConfig {
            FirebaseApp.configure()
            isConfig = true
        }
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
            imgAddNewService.image = selectImg
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func uploadService() {
        //Create storage
        let storageRef = Storage.storage().reference()
        guard selectImage != nil else {
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
                let priceCV: Int? = Int(self.priceAddService.text!)
                let timeCV: Int? = Int(self.priceAddService.text!)
                let newAddService:ServiceBarberShop = ServiceBarberShop(id: idNewService,
                                                                        name: self.nameAddService.text!,
                                                                        price: priceCV!,
                                                                        des: self.desAddServive.text!,
                                                                        time: timeCV!,
                                                                        image: urlImage)
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child("services/\(idNewService)").setValue(["id":newAddService.id,
                                                                       "name":newAddService.name,
                                                                       "price":priceCV!,
                                                                       "image":newAddService.image,
                                                                       "desciption":newAddService.des])
            })
        }
        
    }
    
    @IBAction func btnAddNewService(_ sender: Any) {
        uploadService()
    }
}
