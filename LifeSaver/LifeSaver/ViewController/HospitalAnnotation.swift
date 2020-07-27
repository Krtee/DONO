//
//  HospitalAnnotation.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 27.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit
import MapKit

class HospitalAnnotation: MKPointAnnotation {
        private(set) var hospital : Hospitals
        
        init(hospital: Hospitals) {
            self.hospital = hospital
        }
}
