//
//  HospitalAnnotation.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 25.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import MapKit

class AnnotationManager {
    var mapView: MKMapView
    
    init(forMapView: MKMapView) {
        self.mapView = forMapView
    }
    
    func addAnnoations(forHospitals: [Hospitals]) {
        for hospital in forHospitals {
            let longitude = hospital.longitude
            let latitude = hospital.latitude
            let hAnno = HospitalAnnotation(hospital: hospital)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            hAnno.coordinate = coordinate
            mapView.addAnnotation(hAnno)
        }
    }
}
