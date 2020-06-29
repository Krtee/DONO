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
    let locationManager         = CLLocationManager()
    let geoCoder                = CLGeocoder()
    var previousLocation: CLLocation?
    let regionInMeters: Double  = 10000
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionButton.layer.cornerRadius = directionButton.frame.size.height/2
        checkLocationServices()
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
    
    /**
     Funktion dass in die Map reinzoomt in die Mitte von der Location vom User aus
     */
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region  = MKCoordinateRegion.init(center: location, latitudinalMeters:  regionInMeters, longitudinalMeters:  regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    /**
        Funktion checkt die Authorisation für Locations von den Einstellungen her vom iPhone für die App
     */
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            //Benachrichtigung an den User, dass er seine Location erlauben muss
        }
    }
    
    /**
        Funktion, dass die Authorisation des Users checkt, die er einem gegeben hat.
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
    
    /**
    TODO: 2
     Funktion, wenn der User die Authorisation gegeben hat, die Location "when in use" genehmigt hat
     */
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true //Location dot (der blaue Punkt)
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation() //Delegate Methode mit dem updaten der Location
        previousLocation = getCenterLocation(for: mapView)
    }
    
    /**
     TODO: 2
        Funktion, dass die Mitte der Map hält
     */
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude    = mapView.centerCoordinate.latitude
        let longitude   = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /**
        TODO: 3
        Funktion um von der User location und der Ziellocation einen Weg zu bekommen
     */
    func getDirections() {
        guard let location = locationManager.location?.coordinate else { //schaut ob man die location vom User bereits hat
            //TODO: Inform user we don't have their current location
            return
        }
        let request     = createDirectionsRequest(from: location)
        let directions  = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        /**
            Nachdem man das MKDirections Objekt hat, kann man den Weg hier berechnen
         */
        directions.calculate {
            [unowned self] (response, error) in
            //TODO: Handle error if needed
            
            guard let response = response else { return } //TODO: Show response not available in an alert

            /**
                Handled wenn man mehr als eine Route zurück bekommt
             */
            for route in response.routes {
                //TODO: Kommen noch Navigationsschritte rein? -> let steps = route.steps
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    /**
        TODO: 3
        Helper Funktion für getDirections() für das MKDirections.Request
        Um eine Instanz von MKDirections erstellen zu können, benötigt man eine request (wurde in Z. 116 weitergegeben)
     */
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
        
    /**
        TODO:3
        Die Routen werden wieder entfernt, damit die sich nicht überlappen
    */
    func resetMapView (withNew directions: MKDirections) {
            mapView.removeOverlays(mapView.overlays)
            directionsArray.append(directions)
            let _ = directionsArray.map {
                $0.cancel()
        }
    }
}

extension MapScreen: CLLocationManagerDelegate {
    /**
        Funktion wird immer aufgerufen, wenn der User die Location updated
     */
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Wenn die Lokalisation vom User geupdatet wird
        guard let location = locations.last else {
            return //wenn keine Location da ist. Kondition nicht erfüllt, dann passiert nichts
        }
        
        let locationCenter = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) //users last known location
        let region = MKCoordinateRegion.init(center: locationCenter, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters) //die view vom users center location wird angepasst
        }*/
    
    /**
        Funktion, dass immer aufgerufen wird, wenn die User Authorisation geändert wurde
    */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
   


/**
 TODO: 2
 */
extension MapScreen: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        guard let previousLocation = self.previousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            //TODO: Was genau von der Adresse soll gezeigt werden?
            let streetName      = placemark.thoroughfare ?? ""
            let streetNumber    = placemark.subThoroughfare ?? ""

            DispatchQueue.main.async {
                self.hospitalLabel.text = "\(streetName) \(streetNumber)" //Die Adresse die beim Label angezeigt wird
            }
        }
    }
    /**
        Funktion für die Route
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer           = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor   = .purple
        
        return renderer
    }
}

