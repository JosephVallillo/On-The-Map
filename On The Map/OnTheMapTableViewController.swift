//
//  OnTheMapTableViewController.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/8/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit

//MARK: - OnTheMapTableViewController: UITableViewController

class OnTheMapTableViewController: UITableViewController {

    //MARK: Properties
    let otmDataSource = OnTheMapDataSource.sharedDataSource()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = otmDataSource
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ParseClient.Selectors.StudentLocationsDidUpdate, name: "\(ParseClient.Objects.StudentLocation)\(ParseClient.Notifications.ObjectUpdatedError)", object: nil)
    }
    
    //MARK: Data Source
    func studentLocationsDidUpdate() {
        tableView.reloadData()
    }
    
    //MARK: Display Alert
    private func displayAlert(message: String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentMediaURL = otmDataSource.studentLocations[indexPath.row].student.mediaURL
        
        if let mediaURL = NSURL(string: studentMediaURL) {
            if UIApplication.sharedApplication().canOpenURL(mediaURL) {
                UIApplication.sharedApplication().openURL(mediaURL)
            } else {
                displayAlert(AppConstants.Errors.CannotOpenURL)
            }
        }
        
    }
    
}
