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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hospitalNameLabel.text = hospital?.name
        self.addressLabel.text = hospital?.street
        // Do any additional setup after loading the view.
    }
}
