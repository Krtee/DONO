//
//  MapScreen.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 25.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet weak var hospitalLabel: UILabel!
    
    let locationManager = CoreLocationService.shared
    var annotationManager : AnnotationManager?
    var hospitals: Hospitals?
    let regionInMeters: Double  = 10000
    let geoCoder                = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        annotationManager = AnnotationManager(forMapView: mapView)
        
        guard let hospitals = CoreDataService.defaults.loadData() else {
            return
        }
        
        locationManager.updateCallback = centerViewOnUserLocation
        locationManager.updateLocationAsync()
        
        annotationManager?.addAnnoations(forHospitals: hospitals)
    }
    
    
    //MARK: - Funktion, dass in die Map reinzoom in die Mitte von der Location vom User aus
    func centerViewOnUserLocation(location: CLLocation) {
        let region  = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: - Funktion, dass die Mitte der Map halten soll
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude    = mapView.centerCoordinate.latitude
        let longitude   = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "goToHospitalDetailsSegue", sender: view)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        
        let annoView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annoView == nil {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annoView.isEnabled = true
            annoView.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annoView.rightCalloutAccessoryView = btn
        } else {
            annoView!.annotation = annotation
        }
        
        return annoView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender is MKAnnotationView) {
            let hAnno = (sender as! MKAnnotationView).annotation as! HospitalAnnotation
            if segue.destination is HospitalDetailsViewController {
                let vc = segue.destination as! HospitalDetailsViewController
                vc.hospital = hAnno.hospital
            }
        }
    }
}
