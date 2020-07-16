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
        let context = CoreDataService.defaults.persistentContainer.viewContext
        let entityName = "User"
             
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "email == %@", email)
        request.predicate = predicate

        
        do {
            let results = try context.fetch(request)
            
             
            for r in results {
                if let result = r as? NSManagedObject {
                    let fetchedEmail = result.value(forKey: "email") as? String
                    let fetchedPassword = result.value(forKey: "password") as? String
                    let fetchedUserID = result.value(forKey: "userID") as? Int
                    if email == fetchedEmail! && password == fetchedPassword!{
                        let defaults = UserDefaults.standard
                        
                        defaults.set(fetchedUserID, forKey: "UserID")

                        return true
                        
                        
                    }
                }
            }
        }
        catch let error {
         print(error)
        }
        return false
    }
    
}

