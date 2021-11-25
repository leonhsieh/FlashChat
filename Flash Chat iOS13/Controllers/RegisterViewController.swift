//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

final

class RegisterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appname

    }

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
//因為error是optional，因此再次使用optional binding來unwrap error，並存入物件e
//如果是正式開發，可以考慮在這邊加入一個錯誤提示訊息
//localizedDescription能讓用戶能看見在地化提示訊息
                    print(e.localizedDescription)
                }  else {
//如果沒有錯誤、且email及password都不是nil，就使用performSegue，從本頁導航至ChatViewController頁面
                    
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
//已經在ConstantStruct中，使用static將registerSegue與Constants建立關聯，因此才能寫成Constants.registerSegue
                }
            }
        }
//這邊使用到optional binding：如果emailTextfield.text不是nil，那麼就可以被轉換為string、存入物件email，接著創建使用者帳戶
    }
    
}
