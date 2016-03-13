//
//  Location.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/3/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import MapKit

//MARK: - Location
struct Location {
    
    //MARK: Properties
    let latitude: Double
    let longitude: Double
    let mapString: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    //MARK: Initializer
    init(latitude: Double, longitude: Double, mapString: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
    }
}
