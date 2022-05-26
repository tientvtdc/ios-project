//
//  DetailServiceViewController.swift
//  BarberShop
//
//  Created by Truong Tien on 5/23/22.
//

import UIKit

class DetailServiceViewController: UIViewController {
    var service:Service?
    @IBOutlet weak var serviceImage: UIImageView!
   
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    @IBOutlet weak var servicePriceLabel: UILabel!
    
    @IBOutlet weak var serviceDecriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let service = service{
            serviceNameLabel.text = service.name;
            servicePriceLabel.text = NSNumber(value: service.price) .toVND();
            serviceDecriptionLabel.text = service.description;
            let url = URL(string: service.image)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                serviceImage.image = image
                
            }
            title = service.name;
        }
      
        // Do any additional setup after loading the view.
    }
    
    @IBAction func orderSerivceTap(_ sender: UIButton) {
        performSegue(withIdentifier: "goToOrderServiceScreen", sender: self);
      
    }
    
    @IBAction func back_tap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
     //   self.navigationController?.popToRootViewController(animated: true);
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
        if segue.identifier == "goToOrderServiceScreen" {
           if let orderServiceViewController = segue.destination as? OrderServiceViewController{
            orderServiceViewController.service = service;
            }
        }
    }
}
