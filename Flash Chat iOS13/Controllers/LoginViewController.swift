//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
//    var listener: ListenerRegistration? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.name
        emailTextfield.text = "test@test.com"
        passwordTextfield.text = "123456"
    }
    

    @IBAction func loginPressed(_ sender: UIButton) {
        print("loginPressed", #function)

        if let email = emailTextfield.text,
           let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                    print("implement Login")
                }
        } 
        }
        
    }
}
