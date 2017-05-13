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
