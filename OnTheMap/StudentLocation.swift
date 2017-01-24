//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 24/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    let objectId: String
    let firstName: String
    let lastName: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double

    init?(dict:[String: Any]) {

        guard   let objectId    = dict["objectId"],
                let firstName   = dict["firstName"],
                let lastName    = dict["lastName"],
                let mediaURL    = dict["mediaURL"],
                let latitude    = dict["latitude"],
                let longitude   = dict["longitude"] else {
            return nil
        }

        self.objectId   = objectId as! String
        self.firstName  = firstName as! String
        self.lastName   = lastName as! String
        self.mediaURL   = mediaURL as! String
        self.latitude   = latitude as! Double
        self.longitude  = longitude as! Double
    }
    
}
