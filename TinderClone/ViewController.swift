//
//  ViewController.swift
//  TinderClone
//
//  Created by Adrien Maranville on 4/22/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var signupMode = true;
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }


    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var btnLoginSignUpTop: NSLayoutConstraint!
    @IBOutlet weak var txtBoxUsername: UITextField!
    @IBOutlet weak var txtBoxPassword: UITextField!
    @IBOutlet weak var lblPasswordConfirm: UILabel!
    @IBOutlet weak var txtBoxPasswordConfirm: UITextField!
    @IBOutlet weak var btnLoginSignUp: UIButton!
    @IBAction func btnLoginSignUpPressed(_ sender: Any) {
        let user = PFUser()
        user.username = txtBoxUsername.text
        user.email = txtBoxUserEmail.text
        user.password = txtBoxPassword.text
        
        let acl = PFACL()
        
        acl.getPublicWriteAccess = true
        acl.getPublicReadAccess = true
        user.acl = acl
        
        
        if signupMode {
            if txtBoxUsername.text != "" && txtBoxUserEmail.text != "" && txtBoxPassword.text != "" && txtBoxPasswordConfirm.text != "" {
                if txtBoxPassword.text == txtBoxPasswordConfirm.text {
                    user.signUpInBackground { (success, error) in
                        if error != nil {
                            var errorMessage = "Signup failed. Please try again"
                            let error = error as NSError?
                            if let parseError = error?.userInfo["error"] as? String {
                                errorMessage = parseError
                            }
                            self.lblErrorMessage.alpha = 1
                            self.lblErrorMessage.text = errorMessage
                        } else {
                            self.lblErrorMessage.text = ""
                            self.lblErrorMessage.alpha = 0
                            print("Signed user up")
                        }
                        
                    }
                    
                } else {
                    createAlert(title: "Ooops!", message: "Your passwords don't match")
                }
            }
            else {
                createAlert(title: "Ooops!", message: "Please enter a username and password")
            }
        } else {
            if txtBoxUsername.text != "" && txtBoxPassword.text != "" {
                
                PFUser.logInWithUsername(inBackground: txtBoxUsername.text!, password: txtBoxPassword.text!, block: { (user, error) in
                    
                    if error != nil {
                        var errorMessage = "Log in failed. Please try again"
                        let error = error as NSError?
                        if let parseError = error?.userInfo["error"] as? String {
                            errorMessage = parseError
                        }
                        self.lblErrorMessage.text = errorMessage
                    } else {
                        self.lblErrorMessage.text = ""
                        print("Logged user in")
                        self.redirectUser()
                    }
                    
                })
                
            }
            else {
                createAlert(title: "Ooops!", message: "Please enter an email and password")
            }
        }
    }
    @IBOutlet weak var lblNeedAccount: UILabel!
    @IBOutlet weak var btnSwitcher: UIButton!
    @IBAction func btnSwitcherPressed(_ sender: Any) {
        self.lblErrorMessage.text = ""
        self.lblErrorMessage.alpha = 0
        if signupMode {
            signupMode = false;
            btnLoginSignUp.setTitle("Log In", for: [])
            btnSwitcher.setTitle("Sign Up", for: [])
            lblNeedAccount.text = "Don't have an account?"
            
            lblPasswordConfirm.alpha = 0
            txtBoxPasswordConfirm.alpha = 0
            lblUserEmail.alpha = 0
            txtBoxUserEmail.alpha = 0
            
            btnLoginSignUpTop.constant = -130
        } else {
            signupMode = true;
            btnLoginSignUp.setTitle("Sign Up", for: [])
            btnSwitcher.setTitle("Log In", for: [])
            lblNeedAccount.text = "Already have an account?"
            
            lblPasswordConfirm.alpha = 1
            txtBoxPasswordConfirm.alpha = 1
            lblUserEmail.alpha = 1
            txtBoxUserEmail.alpha = 1
            
            btnLoginSignUpTop.constant = 36
            
            
        }
    }
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var txtBoxUserEmail: UITextField!


    override func viewDidAppear(_ animated: Bool) {
        redirectUser()
    }
    
    func redirectUser() {
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["photo"] != nil {
                
                performSegue(withIdentifier: "swipeFromInitSegue", sender: self)
                
            } else {
                performSegue(withIdentifier: "goToProfile", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

