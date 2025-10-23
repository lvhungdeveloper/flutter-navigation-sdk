// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()

  private let _locationManager = CLLocationManager()

  override init() {
    super.init()
    
    // Set delegate FIRST before configuring
    _locationManager.delegate = self
    
    // Configure location manager for better accuracy and heading updates
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    _locationManager.distanceFilter = kCLDistanceFilterNone
    
    // Configure heading filter for smoother rotation
    // Only report heading changes of 5 degrees or more
    _locationManager.headingFilter = 5
  }

  func requestAlwaysAuthorization() {
    _locationManager.requestAlwaysAuthorization()
  }

  func startUpdatingLocation() {
    _locationManager.startUpdatingLocation()
    // Enable heading updates to show device orientation on the blue location arrow
    if CLLocationManager.headingAvailable() {
      _locationManager.startUpdatingHeading()
    }
  }

  func stopUpdatingLocation() {
    _locationManager.stopUpdatingLocation()
    // Stop heading updates when location updates are stopped
    if CLLocationManager.headingAvailable() {
      _locationManager.stopUpdatingHeading()
    }
  }

  func allowBackgroundLocationUpdates(allow: Bool) {
    _locationManager.allowsBackgroundLocationUpdates = allow
  }
  
  // MARK: - CLLocationManagerDelegate
  
  // These delegate methods are required for CLLocationManager to actually
  // work and provide location/heading updates to the system and GMSMapView
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Location updates are automatically used by GMSMapView when isMyLocationEnabled = true
    // No need to manually handle here, but this delegate method must be implemented
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    // Heading updates are automatically used by GMSMapView to rotate the blue location arrow
    // No need to manually handle here, but this delegate method must be implemented
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // Handle location errors
    print("LocationManager error: \(error.localizedDescription)")
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    // Handle authorization changes
    switch manager.authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      // Authorization granted, location updates can proceed
      break
    case .denied, .restricted:
      print("Location authorization denied or restricted")
    case .notDetermined:
      // Will be handled by requestAlwaysAuthorization()
      break
    @unknown default:
      break
    }
  }
}
