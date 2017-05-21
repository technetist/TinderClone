//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Adrien Maranville on 5/12/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBAction func btnUploadPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var switchUserGender: UISwitch!
    @IBOutlet weak var switchInterestedGender: UISwitch!

    @IBAction func btnUpdateUser(_ sender: Any) {
        PFUser.current()?["isFemale"] = switchUserGender.isOn
        PFUser.current()?["isInterestedInWomen"] = switchInterestedGender.isOn
        
        let imageData = UIImageJPEGRepresentation(imgUserPhoto.image!, 0)
        
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                var errorMessage = "Update failed. Please try again"
                let error = error as NSError?
                if let parseError = error?.userInfo["error"] as? String {
                    errorMessage = parseError
                }
                self.lblErrorMessage.text = errorMessage
            } else {
                self.lblErrorMessage.text = ""
                print("User data saved")
                
                self.performSegue(withIdentifier: "showSwipingSegue", sender: self)
            }

        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgUserPhoto.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            switchUserGender.setOn(isFemale, animated: false)
        }
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            switchInterestedGender.setOn(isInterestedInWomen, animated: false)
        }
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground(block: { (data, error) in
                if error != nil {
                    self.lblErrorMessage.text = error as? String
                } else if let imageData = data {
                    if let downloadedImage = UIImage(data: imageData) {
                        self.imgUserPhoto.image = downloadedImage
                    }
                }
            })
        }
        
        //Create extra users
        
//        let urlArray = ["http://immagini.disegnidacolorareonline.com/cache/data/disegni-colorati/serie-tv/disegno-ben-ten-colorato-600x600.jpg", "https://s-media-cache-ak0.pinimg.com/736x/26/2d/d4/262dd427dedd15872c2c85337dc0936e.jpg", "https://metrouk2.files.wordpress.com/2015/02/ad_158595188.jpg", "https://www.mememaker.net/static/images/templates/755243.jpg", "http://2.bp.blogspot.com/-pP2pk5QX9es/T-nXkChsLBI/AAAAAAAAAMg/2OlsraSIZOQ/s1600/batman__brave_and_the_bold_by_noahconners-d2yeii2.jpg", "https://pbs.twimg.com/profile_images/1219552606/homersimpson_400x400.jpg", "https://s-media-cache-ak0.pinimg.com/originals/eb/7b/e9/eb7be9912427044a47a2bae6620f7617.jpg", "http://www.homedepot.com/catalog/productImages/1000/8f/8f18dc40-a346-4473-a5a5-26affc0f48eb_1000.jpg"]
//        
//        var counter = 0
//        
//        for urlString in urlArray {
//            counter += 1
//            let url = URL(string: urlString)!
//            do {
//                let data = try Data(contentsOf: url)
//                let imageFile = PFFile(name: "photo.png", data: data)
//                let user = PFUser()
//                
//                user["photo"] = imageFile
//                user.username = String(counter)
//                user.password = "secret"
//                user["isInterestedInWomen"] = false
//                user["isFemale"] = false
//                
//                let acl = PFACL()
//                
//                acl.getPublicWriteAccess = true
//                user.acl = acl
//                
//                user.signUpInBackground(block: { (success, error) in
//                    if error != nil {
//                        print(error!)
//                    } else if success{
//                        print("Users added")
//                    }
//                })
//                
//            } catch {
//                print("Could not get url")
//            }
//        }
//
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
