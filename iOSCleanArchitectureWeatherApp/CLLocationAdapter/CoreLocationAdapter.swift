//
//  CoreLocationAdapter.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 03/10/2022.
//

import Foundation
import CoreLocation

// MARK: - CoreLocationAdapter

final class CoreLocationAdapter: NSObject, CLLocationManagerDelegate {

    private let locationManager: CLLocationManager
    var locationFetchCompletions: ((Double, Double) -> Void)?

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }

    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        var authorizationStatus: CLAuthorizationStatus = .notDetermined

        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        if authorizationStatus == CLAuthorizationStatus.notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.startUpdatingLocation()
            }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation

        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        locationFetchCompletions?(lat, lon)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle Error here
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        } else if authStatus == CLAuthorizationStatus.authorizedAlways ||
                    authStatus == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            // Handle this block
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            // The user denied authorization
        } else if status == CLAuthorizationStatus.authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}
