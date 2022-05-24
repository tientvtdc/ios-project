//
//  AddServiceViewController.swift
//  BarberShop
//
//  Created by buiduykhanh on 5/21/22.
//

import UIKit
import FirebaseStorage
import Firebase

class AddServiceViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imgAddNewService: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAddNewService.layer.cornerRadius = 5
        FirebaseApp.configure();
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
        if let selectImage = info[.originalImage] as? UIImage
        {
            imgAddNewService.image = selectImage
            picker.dismiss(animated: true, completion: nil)
            let storage = Storage.storage().reference()
            guard let imageData = selectImage.pngData() else {
                return
            }

            let ref = storage.child("images/file.png")

            ref.putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Failed to upload")
                    return
            }
                storage.child("images/file.png").downloadURL(completion: { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    let urlString = url.absoluteString
                    print("Download URL: \(urlString)")
                    UserDefaults.standard.set(urlString, forKey: "url")
                })
            })
            
        }
    }
    
    @IBAction func btnAddNewService(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
