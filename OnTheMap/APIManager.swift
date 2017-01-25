//
//  APIManager.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 23/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import Foundation

class APIManager {
    
    private static let udacityEndpoint      = "https://www.udacity.com/api/session"
    private static let parseApplicationID   = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let parseAPIKey          = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static func udacityLogin(username:String, password:String, completion: @escaping (_ isRegistered: Bool?, _ expiration: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: udacityEndpoint)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completion(nil, nil)
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 0))
            let newData = data?.subdata(in: range) /* subset response data! */
            
            if let json = try? JSONSerialization.jsonObject(with: newData!) as? [String:Any],
                let account = json?["account"] as? [String:Any],
                let session = json?["session"] as? [String:Any],
                let registered = account["registered"] as? Bool,
                let userKey = account["key"] as? String,
                let expiration = session["expiration"] as? String {
                Singleton.sharedInstance.userKey = userKey
                completion(registered, expiration)
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    static func getStudentLocations(completion: @escaping (_ studentsLocation:[StudentLocation]?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completion(nil)
                return
            }

            var studentsLocation:[StudentLocation] = []
            if let json = try? JSONSerialization.jsonObject(with: data!) as? [String:Any],
                let results = json?["results"] as? [Any] {
                
                for result in results {
                    if let student = result as? [String:Any], let studentLocation = StudentLocation(dict: student) {
                        studentsLocation.append(studentLocation)
                    }
                }
                completion(studentsLocation)
            } else {
                completion(nil)
            }
            
        }
        task.resume()
    }
    
    static func deleteSession(completion: @escaping (_ success: Bool) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: udacityEndpoint)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completion(false)
                return
            }
            completion(true)
//            let range = Range(uncheckedBounds: (5, data!.count - 5))
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    static func postLocation(address:String, url:String, latitude:Double, longitude:Double, completion: @escaping (_ success: Bool) -> Void) {
        getUserData { (success, firstName, lastName) in
            if success {
                let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
                request.httpMethod = "POST"
                request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = "{\"firstName\": \"\(firstName!)\", \"lastName\": \"\(lastName!)\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
                let session = URLSession.shared
                let task = session.dataTask(with: request as URLRequest) { data, response, error in
                    if error != nil { // Handle error…
                        completion(false)
                        return
                    }
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                    completion(true)
                }
                task.resume()
            } else {
                completion(false)
            }
        }
    }
    
    static func getUserData(userKey: String = Singleton.sharedInstance.userKey!, completion: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completion(false, nil, nil)
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 0))
            let newData = data?.subdata(in: range) /* subset response data! */
            
            if let json = try? JSONSerialization.jsonObject(with: newData!) as? [String:Any],
                let user = json?["user"] as? [String:Any],
                let firstName = user["first_name"] as? String,
                let lastName = user["last_name"] as? String {
                completion(true, firstName, lastName)
            } else {
                completion(false, nil, nil)
            }
        }
        task.resume()
    }
    
}
