//
//  Singleton.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 25/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import Foundation

class Singleton {
    
    public static let sharedInstance = Singleton()
    private init() {}
    
    var userKey:String?
    var studentsLocation:[StudentLocation]?
    
}
