//
//  HospitalDetailsViewController.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 25.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class HospitalDetailsViewController: UIViewController {

    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var hospital : Hospitals?
    
    //var hospitalDetail: Hospital?
    @IBAction func toCalenderController(_ sender: Any) {
        UserDefaults.standard.set(hospital?.hospitalID, forKey: "hospitalID")
        
        self.performSegue(withIdentifier: "hospitaltoCalendersegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hospitalNameLabel.text = hospital?.name
        self.addressLabel.text = hospital?.street
        // Do any additional setup after loading the view.
    }
}
