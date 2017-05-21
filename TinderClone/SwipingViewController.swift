//
//  SwipingViewController.swift
//  TinderClone
//
//  Created by Adrien Maranville on 5/13/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var lblAlert: UILabel!
    @IBOutlet weak var imgMatches: UIImageView!
    
    @IBOutlet weak var btnRefreshLabel: UIButton!
    @IBAction func btnRefresh(_ sender: Any) {
        PFUser.current()?.fetchInBackground(block: { (objects, error) in
            self.updateImage()
        })
        
    }
    var displayedUserId = ""
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width/2+translation.x, y: self.view.bounds.height/2+translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width/2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/200)
        
        let scale = min(abs(100/xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
                
            } else if label.center.x > self.view.bounds.width-100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" && displayedUserId != "" {
                
                PFUser.current()?.addUniqueObjects(from: [displayedUserId], forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        self.updateImage()
                    }
                })
                
                
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        }
    }
    
    func updateImage() {
        
        let query = PFUser.query()
        
        query?.whereKey("isFemale", equalTo: (PFUser.current()?["isInterestedInWomen"])!)
        
        query?.whereKey("isInterestedInWomen", equalTo: (PFUser.current()?["isFemale"])!)
        
        
        let uid = PFUser.current()?.objectId
        var ignoredUsers = [""]
        
        ignoredUsers.append(uid!)
        if let acceptedUsers = PFUser.current()?["accepted"] {
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"] {
            ignoredUsers += rejectedUsers as! Array
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
            }
        }
        
        query?.limit = 1
        
        query?.countObjectsInBackground(block: { (count, error) in
            var counter = 0
            if Int32(counter) < count {
                self.imgMatches.alpha = 1
                self.lblInstructions.alpha = 1
                self.lblAlert.alpha = 0
                self.btnRefreshLabel.alpha = 0
                
                query?.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        print(error!)
                    }else if let users = objects {
                        for object in users {
                            counter += 1
                            
                            if let user = object as? PFUser {
                                
                                self.displayedUserId = user.objectId!
                                
                                let imageFile = user["photo"] as! PFFile
                                
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if error != nil {
                                        print(error!)
                                    } else if let imageData = data {
                                        self.imgMatches.image = UIImage(data: imageData)
                                    }
                                })
                            }
                        }
                    }
                })
            } else {
                self.imgMatches.alpha = 0
                self.lblInstructions.alpha = 0
                self.lblAlert.alpha = 1
                self.btnRefreshLabel.alpha = 1
            }
        })
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        imgMatches.isUserInteractionEnabled = true
        
        imgMatches.addGestureRecognizer(gesture)
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            if error != nil {
                print(error!)
            } else if let userLocation = geopoint {
                PFUser.current()?["location"] = userLocation
                
                PFUser.current()?.saveInBackground()
            }
        }
        
        updateImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            PFUser.logOut()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
