//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 24/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel, urlLabel: UILabel!

    func initWithData(studentLocation: StudentLocation) {
        nameLabel.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        urlLabel.text = studentLocation.mediaURL
    }

}
