//
//  RegisterViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 22.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit
import CoreData


class RegisterViewController: UIViewController {
    
    var index: Int?

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reppassword: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        if email.text!.count > 0 && password.text!.count > 0 {
            if password.text == reppassword.text {
                if !checkIfUserExist(email: email.text!) {
                    let user: User = CoreDataUserService.defaults.createUser(_email: email.text!, _password: password.text!)
                    UserDefaults.standard.set(user.userID, forKey: "userID")
                    self.performSegue(withIdentifier: "registersegue", sender: self)
                }
                else{
                    print("user already exist")
                }
                
            }
            else {
                print("password does not match")
            }
             
        } else{
            print("somethin is missing")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func checkIfUserExist (email: String)-> Bool {
        do {
            
            let user: User? = CoreDataUserService.defaults.loadfromID(id: email)
            
            if user != nil {
                return true
            }
            

        }
        catch let error {
         print(error)
        }
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
