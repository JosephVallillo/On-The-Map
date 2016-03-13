//
//  OnTheMapTabBarController.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/8/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit

//MARK: - OnTheMapTabBarController: UITabBarController

class OnTheMapTabBarController: UITabBarController {

    //MARK: Properties
    private let udacityClient = UdacityClient.sharedClient()
    private let parseClient = ParseClient.sharedClient()
    private let otmDataSource = OnTheMapDataSource.sharedDataSource()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ParseClient.Selectors.StudentLocationsDidError, name: "\(ParseClient.Objects.StudentLocation)\(ParseClient.Notifications.ObjectUpdatedError)", object: nil)
    }
    
    //MARK: Actions
    @IBAction func logout(sender: UIBarButtonItem) {
        udacityClient.logout { (success, error) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func addStudentLocation(sender: UIBarButtonItem) {
        if let currentStudent = otmDataSource.currentStudent {
            parseClient.studentLocationWithUserKey(currentStudent.uniqueKey, completionHandler: { (location, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let location = location {
                        self.displayOverwriteAlert({ (alert) -> Void in
                            self.launchPostingModal(location.objectID)
                        })
                    } else {
                        self.launchPostingModal()
                    }
                })
            })
        }
    }
    
    @IBAction func refreshStudentLocations(sender: UIBarButtonItem) {
        otmDataSource.refreshStudentLocations()
    }
    
    //MARK: Data Source
    func studentLocationsDidError() {
        displayAlert(AppConstants.Errors.CouldNotUpdateStudentLocations)
    }
    
    //MARK: Display Alerts
    private func displayAlert(message: String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func displayOverwriteAlert(completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertView = UIAlertController(title: AppConstants.Alerts.OverwriteTitle, message: AppConstants.Alerts.OverwriteMessage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Overwrite, style: .Default, handler: completionHandler))
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Cancel, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func launchPostingModal(objectID: String? = nil) {
        if let postingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OnTheMapPostingViewController") as? OnTheMapPostingViewController {
            if let objectID = objectID {
                postingViewController.objectID = objectID
            }
            self.presentViewController(postingViewController, animated: true, completion: nil)
        }
    }
    
}
