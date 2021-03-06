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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        DispatchQueue.main.async {
            
            let url = URL(string: ((view.annotation?.subtitle)!)!)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                Utility.genericAlert(title: "Warning", message: "URL \(url) can not be open!", sender: self)
            }
            
        }
    }
    
    @IBAction func refreshStudentsLocationAction(_ sender: Any) {
        activityIndicator.startAnimating()
        Utility.getStudentsLocation(fromCacheIfAvailable: initalLoading) { (studentsLocation) in
            self.activityIndicator.stopAnimating()
            if studentsLocation == nil {
                Utility.genericAlert(title: "Warning", message: "Students location download failed", sender: self)
            } else {
                DispatchQueue.main.async {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(self.studentsLocationToAnnotations(studentsLocation!))
                    Singleton.sharedInstance.studentsLocation = studentsLocation
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
