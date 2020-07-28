//
//  ProfileViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 28.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "userID")
        
        self.performSegue(withIdentifier: "logoutsegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
