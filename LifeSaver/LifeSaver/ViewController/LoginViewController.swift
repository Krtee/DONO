//
//  LoginViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 22.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit
import CoreData

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
            
            if checkIfUserExist(email: emailTextField.text!, password: passwordTextField.text!) {
                                                
                self.performSegue(withIdentifier: "loginsegue", sender: self)
            }
            else{
                print("user not exist")
            }
             
        }
        else{
            print("yo missing somthin")
        }
    }
    
    func checkIfUserExist (email: String, password: String)-> Bool {
        do {
            
            let user: User? = CoreDataUserService.defaults.loadfromID(id: email)
            
            if user != nil {
                if email == user?.email && password == user?.password{
                    let defaults = UserDefaults.standard
                    
                    defaults.set(user?.userID, forKey: "userID")

                    return true
                }
                
            } else{
                print("could not load user: \(email)")
            }
             
        }
        catch let error {
         print(error)
        }
        return false
    }
    
}

