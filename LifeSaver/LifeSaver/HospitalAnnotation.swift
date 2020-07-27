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
    var mapView: MapScreen!
    
    init(hospital: Hospitals) {
        self.hospital = hospital
    }
    
    func addAnnoations(hospitals: [Hospitals]) {
        for hospital in hospitals {
            let longitude = hospital.longitude
            let latitude = hospital.latitude
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anno = HospitalAnnotation(hospital: hospital)
            anno.coordinate = coordinate
            //mapView.addAnnotation(anno)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender is MKAnnotationView) {
            let hAnno = (sender as! MKAnnotationView).annotation as! HospitalAnnotation
            if segue.destination is HospitalDetailsViewController {
                let vc = segue.destination as! HospitalDetailsViewController
                vc.hospital = hAnno.hospital
            }
        }
    }
}
