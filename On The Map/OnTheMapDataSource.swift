//
//  OnTheMapDataSource.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/6/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit

//MARK: - OnTheMapDataSource: NSObject
class OnTheMapDataSource: NSObject {
    
    //MARK: Properties
    private let parseClient = ParseClient.sharedClient()
    var studentLocations = [StudentLocation]()
    var currentStudent: Student? = nil
    
    //MARK: Initializers
    override init() {
        super.init()
    }
    
    //MARK: Singleton Instance
    private static var sharedInstance = OnTheMapDataSource()
    
    class func sharedDataSource() -> OnTheMapDataSource {
        return sharedInstance
    }
    
    //MARK: Notifications
    private func sendDataNotification(notificationName: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
    
    //MARK: Refresh Student Locations
    func refreshStudentLocations() {
        parseClient.studentLocations { (students, error) -> Void in
            if let _ = error {
                self.sendDataNotification("\(ParseClient.Objects.StudentLocation)\(ParseClient.Notifications.ObjectUpdatedError)")
            } else {
                self.studentLocations = students!
                self.sendDataNotification("\(ParseClient.Objects.StudentLocation)\(ParseClient.Notifications.ObjectUpdated)")
            }
        }
    }
}

//MARK: - StudentLocationDataSource: UITableViewDataSource
extension OnTheMapDataSource: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tempCell = UITableViewCell()
        if let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationTableViewCell") as? StudentLocationTableViewCell {
            let studentLocation = studentLocations[indexPath.row]
            cell.configureWithStudentLocation(studentLocation)
            return cell
        }
        return tempCell
    }
    
}