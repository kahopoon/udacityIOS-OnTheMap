//
//  TableViewVC.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 24/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit

class TableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var studentsLocation:[StudentLocation] = []
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.initWithData(studentLocation: studentsLocation[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: studentsLocation[indexPath.row].mediaURL)!, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @IBAction func refreshStudentsLocationAction(_ sender: Any) {
        activityIndicator.startAnimating()
        Utility.getStudentsLocation(fromCacheIfAvailable: false) { (studentsLocation) in
            if studentsLocation == nil {
                Utility.genericAlert(title: "Warning", message: "Students location download failed", sender: self)
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.studentsLocation = studentsLocation!
                    self.tableView.reloadData()
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
