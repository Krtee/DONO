//
//  MapViewDelegate.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 27.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    var mapView: MKMapView!


    func mapView(_mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let pinIdentifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotationView as? MKAnnotation, reuseIdentifier: pinIdentifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
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
