//
//  LocationService.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 26.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationService: NSObject, CLLocationManagerDelegate {
    static let shared = CoreLocationService()
    private let locationManager = CLLocationManager()
    var lastLocation : CLLocation?
    var updateCallback : ((CLLocation) -> Void)?
    
    private override init() {
        super.init()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
        }
    }
    
    public func updateLocationAsync() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lastLocation = location
        }
        
        if (updateCallback != nil) {
            updateCallback!(lastLocation!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
