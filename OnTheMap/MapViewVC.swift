//
//  MapViewVC.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 24/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var initalLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshStudentsLocationAction(self)
        initalLoading = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshStudentsLocationAction(self)
    }

    func studentsLocationToAnnotations(_ studentsLocation: [StudentLocation]) -> [MKPointAnnotation] {
        var annotaions:[MKPointAnnotation] = []
        for studentLocation in studentsLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaURL
            annotaions.append(annotation)
        }
        return annotaions
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: ((view.annotation?.subtitle)!)!)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func refreshStudentsLocationAction(_ sender: Any) {
        activityIndicator.startAnimating()
        Utility.getStudentsLocation(fromCacheIfAvailable: initalLoading) { (studentsLocation) in
            if studentsLocation == nil {
                Utility.genericAlert(title: "Warning", message: "Students location download failed", sender: self)
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(self.studentsLocationToAnnotations(studentsLocation!))
                }
            }
        }
    }

    @IBAction func logoutButtonAction(_ sender: Any) {
        activityIndicator.startAnimating()
        Utility.logout { (success) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
