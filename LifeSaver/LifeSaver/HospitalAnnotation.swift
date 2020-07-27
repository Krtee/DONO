//
//  HospitalAnnotation.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 25.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import MapKit

class HospitalAnnotation : MKPointAnnotation {
    var hospital : Hospitals
    
    init(hospital: Hospitals) {
        self.hospital = hospital
    }
}
