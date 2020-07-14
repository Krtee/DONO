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
                    saveData()
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
    
    func saveData () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        let entityName = "User"
        
        let newEntity = NSEntityDescription.entity(forEntityName: entityName, in: contex)
        
        let user = NSManagedObject(entity: newEntity!, insertInto: contex)
        
        user.setValue(email.text, forKey: "email")
        user.setValue(password.text, forKey: "password")
        
        do {
            print("IT WORKED")
            try contex.save()
            

        } catch {
            print("hii")
        }
        
    }
    
    func checkIfUserExist (email: String)-> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        let entityName = "User"
             
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "email == %@", email)
        request.predicate = predicate

        
        do {
            let results = try contex.fetch(request)
            
            print("i am here: \(results)")
            
            if results.count >= 1 {
                print("yup")
                return true
            }
            /*
             
            for r in results {
                if let result = r as? NSManagedObject {
                    let title = result.value(forKey: "email") as? String
                    print(title)
                }
                if r.count >=1 {
                    return true
                }
            }*/
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
