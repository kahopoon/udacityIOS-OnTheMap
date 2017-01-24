//
//  Utility.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 23/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Utility {
    
    public static let sharedInstance = Utility()
    private init() {}
    
    var userKey:String?
    var studentsLocation:[StudentLocation]?
    
    static func genericAlert(title: String, message: String, sender: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async { 
            sender.present(alert, animated: true, completion: nil)
        }
    }
    
    static func saveUsernamePassword(username:String, password: String) {
        // please forgive me using unencrypted user defaults...
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    static func getUsernamePassword() -> (username:String?, password: String?) {
        if let username = UserDefaults.standard.object(forKey: "username"), let password = UserDefaults.standard.object(forKey: "password") {
            return (username as? String, password as? String)
        }
        return (nil, nil)
    }

    static func clearUsernamePassword() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    static func getStudentsLocation(fromCacheIfAvailable: Bool, completion: @escaping (_ result: [StudentLocation]?) -> Void) {
        if fromCacheIfAvailable && Utility.sharedInstance.studentsLocation != nil {
            completion(Utility.sharedInstance.studentsLocation!)
        } else {
            APIManager.getStudentLocations { (studentsLocation) in
                if studentsLocation == nil {
                    completion(nil)
                } else {
                    Utility.sharedInstance.studentsLocation = studentsLocation
                    completion(studentsLocation!)
                }
            }
        }
    }
    
    static func logout(completion: @escaping (_ success: Bool) ->  Void) {
        clearUsernamePassword()
        APIManager.deleteSession { (success) in
            completion(success)
        }
    }
    
    static func geocoding(fromAddress: String, completion: @escaping (_ success: Bool, _ result: MKPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(fromAddress) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    completion(true, MKPlacemark(placemark: placemarks.first!))
                } else {
                    completion(true, nil)
                }
            } else {
                completion(false, nil)
            }
        }
    }
    
}
