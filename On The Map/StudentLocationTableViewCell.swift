//
//  StudentLocationTableViewCell.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/6/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit

//MARK: - StudentLocationTableViewCell: UITableViewCell
class StudentLocationTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    //Mark: Configure UI
    func configureWithStudentLocation(studentLocation: StudentLocation) {
        pinImageView.image = UIImage(named: "Pin")
        nameLabel.text = studentLocation.student.fullName
        urlLabel.text = studentLocation.student.mediaURL
    }
}
