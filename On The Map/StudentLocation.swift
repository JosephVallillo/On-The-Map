//
//  StudentLocation.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/3/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

//MARK: - StudentLocaiton
struct StudentLocation {
    
    //MARK: Properties
    let objectID: String
    let student: Student
    let location: Location
    
    //MARK: Initializers
    init(dictionary: [String:AnyObject]) {
        
        objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String ?? ""
        
        //get student data
        let uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String ?? ParseClient.DefaultValues.ObjectID
        let firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String ?? ParseClient.DefaultValues.FirstName
        let lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String ?? ParseClient.DefaultValues.LastName
        let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String ?? ParseClient.DefaultValues.MediaURL
        student = Student(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mediaURL: mediaURL)
        
        //get location data
        let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double ?? 0.0
        let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double ?? 0.0
        let mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String ?? ParseClient.DefaultValues.MapString
        location = Location(latitude: latitude, longitude: longitude, mapString: mapString)
    }
    
    init(student: Student, location: Location) {
        objectID = ""
        self.student = student
        self.location = location
    }
    
    init(objectID: String, student: Student, location: Location) {
        self.objectID = objectID
        self.student = student
        self.location = location
    }
    
    //MARK: Conveniece Initializers
    static func locationFromDictionaries(dictionaries: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        for studentDictionary in dictionaries {
            studentLocations.append(StudentLocation(dictionary: studentDictionary))
        }
        return studentLocations
    }
}