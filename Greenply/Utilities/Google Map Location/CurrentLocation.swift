//
//  CurrentLocation.swift
//  Greenply
//
//  Created by Jitendra on 10/17/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import MapKit

class CurrentLocation: NSObject,CLLocationManagerDelegate {
    var successFetching:((_ latitude: Double, _ longitude: Double)->())!
    var failureFetching:((_ message:String)->())!
    var isLocationProvided = false
    let locationManager = CLLocationManager()
    
    static let sharedInstance: CurrentLocation = {
        let obj = CurrentLocation()
        return obj
    }()
    
    override init() {
        super.init()
        
        //mandatory settings to be done
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self;
    }
    
    //Call this method from outside to fetch current location
    func fetchCurrentUserLocation(onSuccess success:@escaping (_ latitude: Double, _ longitude: Double)->(), failure:@escaping (_ message:String)->()) {
        successFetching = success
        failureFetching = failure
        isLocationProvided = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .denied: //NotDetermined, .Restricted
                failureFetching(LOCATION_DISABLED)
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                break
            }
        } else {
            failureFetching(LOCATION_DISABLED)
        }
        failureFetching(LOCATION_DISABLED)

      
    }
}

extension CurrentLocation {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !isLocationProvided else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        let userLocation:CLLocation = locations.last! // Get the user location in CLLocation object
        successFetching(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        isLocationProvided = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        failureFetching(LOCATION_FETCH_FAILED)
        
    }
    
    func getStateCityWithLatAndLong(_ latitude: Double, longitude: Double, countryDetails:@escaping (_ stateName:String, _ cityName:String)->()){
         let geoCoder = CLGeocoder()
 
            let loca = CLLocation(latitude: latitude, longitude: longitude)
            geoCoder.reverseGeocodeLocation(loca) { (placemarks, error) in // this is the last line that is being called
                var placemark : CLPlacemark!
                placemark = placemarks?[0]
              countryDetails(placemark.addressDictionary!["State"] as! String, placemark.addressDictionary?["City"] as! String)
              
                
            }

    }

}
