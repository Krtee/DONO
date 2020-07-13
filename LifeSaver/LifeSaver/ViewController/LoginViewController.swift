//
//  LoginViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 22.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var displayText: String?
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("Login Button pressed")
        
        if emailTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
            
            let email = emailTextField.text
            let password = passwordTextField.text
             
        }
    }
    
}

