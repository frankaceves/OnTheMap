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
    let studentObjectId : String
    let studentUniqueKey : String
    
    init(dictionary: [String:AnyObject]) {
        studentFirstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        studentLastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        studentLatitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        studentlongitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        locationMapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        studentMediaURL = dictionary[ParseClient.JSONResponseKeys.URL] as? String
        studentObjectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        studentUniqueKey = dictionary[ParseClient.JSONResponseKeys.UdacityID] as! String
    }
}
