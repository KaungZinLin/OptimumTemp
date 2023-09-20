//
//  LocationManager.swift
//  OptimumTempSwiftUI
//
//  Created by Kaung Zin Lin on 19.09.23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    var latitide: Double {
        locationManager.location?.coordinate.latitude ?? 37.322998
    }
    
    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? -122.032181
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case.authorizedWhenInUse:
            // Location Services Available
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            authorizationStatus = .restricted
            break
        case .denied:
            authorizationStatus = .denied
            break
        case .authorizedAlways:
            authorizationStatus = .authorizedAlways
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}
