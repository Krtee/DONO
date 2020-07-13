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
                saveData()
            }
            else {
                
            }
             
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func saveData () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        let entityName = "User"
        
        let newEntity = NSEntityDescription.entity(forEntityName: entityName, in: contex)
        
        let user = NSManagedObject(entity: newEntity!, insertInto: contex)
        
        user.setValue(email.text, forKey: "email")
        user.setValue(password, forKey: "password")
        
        do {
            print("IT WORKED")
            try contex.save()
        } catch {
            print("hii")
        }
        
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
