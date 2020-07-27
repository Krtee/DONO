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

class MapScreen: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var directionButton: UIButton!
    
    let locationManager = CoreLocationService.shared
    
    var hospitals: HospitalAnnotation?
    
    var directionsArray: [MKDirections] = []
    let regionInMeters: Double  = 10000
    let geoCoder                = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionButton.layer.cornerRadius = directionButton.frame.size.height/2
        mapView.showsUserLocation = true
        
        guard let hospitals = CoreDataService.defaults.loadData() else {
            return
        }
        
        locationManager.updateCallback = centerViewOnUserLocation
        locationManager.updateLocationAsync()
        
        addAnnoations(hospitals: hospitals)
    }
    
    @IBAction func DirectionButtonPressed(_ sender: UIButton) {
            //TODO: Get Directions
            getDirections()
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
    
    //MARK: - Funktion, um von der User Lcoation und der Ziellocation einen Weg zu bekommen
    func getDirections() {
        guard let location = locationManager.lastLocation?.coordinate else { //schaut ob man die Location vom User bereits hat
            //TODO: Inform user we don't have their current location
            return
        }
        
        let request     = createDirectionsRequest(from: location)
        let directions  = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        //Nachdem man das MKDirections Objekt hat, kann man den Weg hier berechnen
        directions.calculate {
            [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert

            //Handled wenn man mehr als eine Route zurück bekommt
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    //MARK: - Helper Funktion für getDirections() für das MKDirections.request, um eine Instanz von MKDirections erstellen zu können, benötigt man eine request (wurde in Z. 116 weiteregegeben)
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = getCenterLocation(for: mapView).coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile //TODO: über was machen wir die Direction? Auto/Fuß/Öffentlich??
        request.requestsAlternateRoutes = true
        
        return request
    }
        
    //MARK: - Reset Map View, Routen werden entfernt, damit die sich nicht überlappen
    func resetMapView (withNew directions: MKDirections) {
            mapView.removeOverlays(mapView.overlays)
            directionsArray.append(directions)
            let _ = directionsArray.map {
                $0.cancel()
        }
    }
}
   

extension MapScreen: MKMapViewDelegate {
    //MARK: - Funktion für das Aussehen der Route
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer           = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor   = .purple
        
        return renderer
    }
    
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
    
    func addAnnoations(hospitals: [Hospitals]) {
        for hospital in hospitals {
            let longitude = hospital.longitude
            let latitude = hospital.latitude
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anno = HospitalAnnotation(hospital: hospital)
            anno.coordinate = coordinate
            mapView.addAnnotation(anno)
        }
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
