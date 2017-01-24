//
//  ConfirmLocationVC.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 24/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var mkPlacemark:MKPlacemark!
    var mapString:String!
    var mediaURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.addAnnotation(mkPlacemark)
        mapView.showAnnotations([mkPlacemark], animated: true)
    }

    @IBAction func finishButtonAction(_ sender: Any) {
        activityIndicator.startAnimating()
        APIManager.postLocation(address: mapString, url: mediaURL, latitude: mkPlacemark.coordinate.latitude, longitude: mkPlacemark.coordinate.longitude) { (success) in
            DispatchQueue.main.async(execute: { 
                self.activityIndicator.stopAnimating()
                if success {
                    let _ = self.navigationController?.popToRootViewController(animated: true)
                } else {
                    Utility.genericAlert(title: "Failed", message: "Your location cannot be added at the moment, please try again later...", sender: self)
                }
            })
        }
    }
    
    @IBAction func cacelButtonAction(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
}
