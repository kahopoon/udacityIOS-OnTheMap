//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 24/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {

    @IBOutlet weak var locationInputTextfield, websiteInputTextfield: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func findButtonAction(_ sender: Any) {
        if !(locationInputTextfield.text?.isEmpty)! && !(websiteInputTextfield.text?.isEmpty)! {
            activityIndicator.startAnimating()
            Utility.geocoding(fromAddress: locationInputTextfield.text!) { (success, mkPlacemark) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                if success {
                    if mkPlacemark != nil {
                        self.performSegue(withIdentifier: "confirmLocationVCSegue", sender: mkPlacemark)
                    } else {
                        Utility.genericAlert(title: "Warning", message: "Nothing found with the address", sender: self)
                    }
                } else {
                    Utility.genericAlert(title: "Warning", message: "Search request failed, please try again later...", sender: self)
                }
            }
        } else {
            Utility.genericAlert(title: "Warning", message: "Please enter location and website to continue...", sender: self)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmLocationVCSegue" {
            let destination = segue.destination as! ConfirmLocationVC
            destination.mkPlacemark = sender as! MKPlacemark
            destination.mapString = locationInputTextfield.text
            destination.mediaURL = websiteInputTextfield.text
        }
    }

}
