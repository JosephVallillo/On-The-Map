//
//  OnTheMapMapViewController.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/8/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit
import MapKit

//MARK: - OnTheMapMapViewController: UIViewController

class OnTheMapMapViewController: UIViewController {
    
    //MARK: Properties
    let otmDataSource = OnTheMapDataSource.sharedDataSource()
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ParseClient.Selectors.StudentLocationsDidUpdate, name: "\(ParseClient.Objects.StudentLocation)\(ParseClient.Notifications.ObjectUpdated)", object: nil)
        otmDataSource.refreshStudentLocations()
    }
    
    //MARK: Data Source
    func studentLocationsDidUpdate() {
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in otmDataSource.studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = studentLocation.location.coordinate
            annotation.title = studentLocation.student.fullName
            annotation.subtitle = studentLocation.student.mediaURL
            annotations.append(annotation)
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
    }
    
    //MARK: Display Alert
    private func displayAlert(message: String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}

//MARK: OnTheMapMapViewController: MKMapViewDelegate
extension OnTheMapMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "OTMPin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.redColor()
            pinView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = NSURL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.sharedApplication().canOpenURL(mediaURL) {
                    UIApplication.sharedApplication().openURL(mediaURL)
                } else {
                    displayAlert(AppConstants.Errors.CannotOpenURL)
                }
            }
        }
    }
}