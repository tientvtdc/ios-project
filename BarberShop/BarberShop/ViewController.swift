//
//  ViewController.swift
//  HamburgerMenu
//
//  Created by Kashyap on 13/11/20.
//
//import Firebase
import UIKit
import Firebase;
import FirebaseStorage;

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HamburgerViewControllerDelegate {
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var leadingConstraintForHamburgerView: NSLayoutConstraint!
    
    @IBOutlet weak var backViewForHamburger: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var storageRef:StorageReference!;
    var serviceList = [Service]();
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.backViewForHamburger.isHidden = true
        //        self.mainBackView.layer.cornerRadius = 40
        self.mainBackView.clipsToBounds = true
        FirebaseApp.configure();
        ref = Database.database().reference();
        storageRef = Storage.storage().reference();
        
        let allPlaces = self.ref.child("services")
        
        allPlaces.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let serviceDict = snap.value as! [String: Any]
                let name = serviceDict["name"] as! String
                let description = serviceDict["description"] as! String
                let image = serviceDict["image"] as! String
                let id = serviceDict["id"] as! String
                let price = serviceDict["price"] as! Double;
                self.serviceList += [Service(id: id, name: name, image: image, price: price, description: description, time: 1)];
                print(name)
                
            }
            self.tableView.reloadData();
        })
        
    }
    
    @IBAction func tappedOnHamburgerbackView(_ sender: Any) {
        self.hideHamburgerView()
    }
    
    func hideHamburgerMenu() {
        self.hideHamburgerView()
    }
    
    private func hideHamburgerView()
    {
        UIView.animate(withDuration: 0.1) {
            self.leadingConstraintForHamburgerView.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHamburger.alpha = 0.0
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHamburgerView.constant = -280
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.backViewForHamburger.isHidden = true
                self.isHamburgerMenuShown = false
            }
        }
    }
    
    
    @IBAction func showHamburgerMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.leadingConstraintForHamburgerView.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHamburger.alpha = 0.75
            self.backViewForHamburger.isHidden = false
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHamburgerView.constant = 0
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.isHamburgerMenuShown = true
            }
            
        }
        
        self.backViewForHamburger.isHidden = false
        
    }
    
    var hamburgerViewController : HamburgerViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "hamburgerSegue")
        {
            if let controller = segue.destination as? HamburgerViewController
            {
                self.hamburgerViewController = controller
                self.hamburgerViewController?.delegate = self
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! ServiceTableViewCell
        let service = self.serviceList[indexPath.row];
        
        cell.name.text = service.name;
        cell.price.text = "\(service.price) đ"
        cell.selectionStyle = .none
        
        let url = URL(string: service.image)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.profilePicImage.image = image
        }
        
        
        cell.backView.layer.cornerRadius = 8
        cell.backView.clipsToBounds = true
        
        cell.profilePicImage.layer.cornerRadius = 25
        cell.profilePicImage.clipsToBounds = true
        print(service.name)
        return cell
    }
    
    private var isHamburgerMenuShown:Bool = false
    private var beginPoint:CGFloat = 0.0
    private var difference:CGFloat = 0.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown)
        {
            if let touch = touches.first
            {
                let location = touch.location(in: backViewForHamburger)
                beginPoint = location.x
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown)
        {
            if let touch = touches.first
            {
                let location = touch.location(in: backViewForHamburger)
                
                let differenceFromBeginPoint = beginPoint - location.x
                
                if (differenceFromBeginPoint>0 || differenceFromBeginPoint<280)
                {
                    difference = differenceFromBeginPoint
                    self.leadingConstraintForHamburgerView.constant = -differenceFromBeginPoint
                    self.backViewForHamburger.alpha = 0.75-(0.75*differenceFromBeginPoint/280)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown)
        {
            if (difference>140)
            {
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHamburgerView.constant = -290
                } completion: { (status) in
                    self.backViewForHamburger.alpha = 0.0
                    self.isHamburgerMenuShown = false
                    self.backViewForHamburger.isHidden = true
                }
            }
            else{
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHamburgerView.constant = -10
                } completion: { (status) in
                    self.backViewForHamburger.alpha = 0.75
                    self.isHamburgerMenuShown = true
                    self.backViewForHamburger.isHidden = false
                }
            }
        }
    }
}

