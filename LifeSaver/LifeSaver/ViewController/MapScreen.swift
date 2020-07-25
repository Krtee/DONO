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
    
    var hospitals: HospitalAnnotation?
    
    var previousLocation: CLLocation?
    var directionsArray: [MKDirections] = []
    let regionInMeters: Double  = 10000
    let locationManager         = CLLocationManager()
    let geoCoder                = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionButton.layer.cornerRadius = directionButton.frame.size.height/2
        checkLocationServices()
        
        guard let hospitals = CoreDataService.defaults.loadData() else {
            return
        }
        
        addAnnoations(hospitals: hospitals)
    }
    
    @IBAction func DirectionButtonPressed(_ sender: UIButton) {
            //TODO: Get Directions
            getDirections()
    }
    
    //LocationManager
    func setUpLocationManager() {
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //MARK: - Funktion, dass in die Map reinzoom in die Mitte von der Location vom User aus
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region  = MKCoordinateRegion.init(center: location, latitudinalMeters:  regionInMeters, longitudinalMeters:  regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //MARK: - Funktion checkt die Authorisation für Locations vong Einstellungen her vom iPhone für die App
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            //Benachrichtigung an den User, dass er seine Location erlauben muss
        }
    }
    
    //MARK: - Check Location Authorization - Funktion, dass die Authorisation des Users checkt, die er einem gegeben hat.
    /**
     - .authorizedWhenInUse
            Location kann nur gecheckt werden, wenn die App in Nutzung ist
     - .denied
            Location wurde nicht genehmigt
     - .notDetermined
            User hat noch nicht geklickt, ob er die Location genehmigt oder nicht
            Fragt nach der Genehmigung
     - .restricted
            Location ist nur bedingt möglich
     - .authorizedAlways
            Location kann immer im Hintergrund gecheckt werden, auch wenn die App "aus" ist
     */
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            //show alert instructing them how to turn on permission
            print("auth denied!!!!!!")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show an alert letting them know whats up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    //MARK: - Funktion, wenn der User die Authorisation gegeben hat, die Location "when in use" genehmigt wurde
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true //Location dot (der blaue Punkt)
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation() //Delegate Methode mit dem updaten der Location
        previousLocation = getCenterLocation(for: mapView)
    }
    
    //MARK: - Funktion, dass die Mitte der Map halten soll
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude    = mapView.centerCoordinate.latitude
        let longitude   = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    //MARK: - Funktion, um von der User Lcoation und der Ziellocation einen Weg zu bekommen
    func getDirections() {
        guard let location = locationManager.location?.coordinate else { //schaut ob man die Location vom User bereits hat
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



extension MapScreen: CLLocationManagerDelegate {
    //MARK: - Funktion wird immer aufgerufen, wenn der User die Location updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Wenn die Lokalisation vom User geupdatet wird
        guard let location = locations.last else {
            return //wenn keine Location da ist. Kondition nicht erfüllt, dann passiert nichts
        }
        let locationCenter = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) //users last known location
        let region = MKCoordinateRegion.init(center: locationCenter, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters) //die view vom users center location wird angepasst
        }
    
    //MARK: - Funktion, dass immer aufgerufen wird, wenn die User Authorisation geändert wurde
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
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
