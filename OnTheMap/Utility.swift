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
    
    static func genericAlert(title: String, message: String, sender: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async { 
            sender.present(alert, animated: true, completion: nil)
        }
    }
    
    static func saveSession(withDateString: String) {
        let validDate = dateFromString(withDateString)
        UserDefaults.standard.set(validDate, forKey: "session")
        UserDefaults.standard.synchronize()
    }
    
    static func deleteSession() {
        UserDefaults.standard.removeObject(forKey: "session")
        UserDefaults.standard.synchronize()
    }
    
    static func isSessionValid() -> Bool {
        if let session = UserDefaults.standard.object(forKey: "session") {
            let sessionDate = session as! Date
            return sessionDate.compare(Date()) == .orderedDescending
        }
        return false
    }
    
    static func getStudentsLocation(fromCacheIfAvailable: Bool, completion: @escaping (_ result: [StudentLocation]?) -> Void) {
        if fromCacheIfAvailable && Singleton.sharedInstance.studentsLocation != nil {
            completion(Singleton.sharedInstance.studentsLocation!)
        } else {
            APIManager.getStudentLocations { (studentsLocation) in
                if studentsLocation == nil {
                    completion(nil)
                } else {
                    Singleton.sharedInstance.studentsLocation = studentsLocation
                    completion(studentsLocation!)
                }
            }
        }
    }
    
    static func logout(completion: @escaping (_ success: Bool) ->  Void) {
        Utility.deleteSession()
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
    
    static func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return date
    }
    
}
