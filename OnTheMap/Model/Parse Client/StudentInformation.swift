//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/8/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import Foundation

struct StudentInformation {
    let studentFirstName : String?
    let studentLastName : String?
    let studentLatitude : Double?
    let studentlongitude : Double?
    let locationMapString : String?
    let studentMediaURL: String?
    let studentObjectId : String?
    let studentUniqueKey : String?
    
    init?(dictionary: [String:AnyObject]) {
        //GUARD STATEMENT RECOMMENDED BY FORUM MENTOR
        guard
        let studentFirstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String,
        let studentLastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String,
        let studentLatitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double,
        let studentlongitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double,
        let locationMapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String,
        let studentMediaURL = dictionary[ParseClient.JSONResponseKeys.URL] as? String,
        let studentObjectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String,
        let studentUniqueKey = dictionary[ParseClient.JSONResponseKeys.UdacityID] as? String
        else { return nil }
        
        //create object
        self.studentFirstName = studentFirstName
        self.studentLastName = studentLastName
        self.studentLatitude = studentLatitude
        self.studentlongitude = studentlongitude
        self.locationMapString = locationMapString
        self.studentMediaURL = studentMediaURL
        self.studentObjectId = studentObjectId
        self.studentUniqueKey = studentUniqueKey
    }
    
    // - MARK: METHODS
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        // iterate through array of dictionaries, each student is a dictionary
        for result in results {
            if let result = StudentInformation(dictionary: result) {
                if students.count < 100 {
                    students.append(result)
                } else {
                    StudentDataInfo.sharedInstance().students = students
                    return StudentDataInfo.sharedInstance().students
                }
                
            }
        }
        return students
    }
}
