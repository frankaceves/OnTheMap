//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/8/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import Foundation

extension ParseClient {
    struct JSONResponseKeys {
        static let UdacityID = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let URL = "mediaURL"
        static let ObjectID = "objectId"
    }
    
    struct Constants {
        var objectID: String!
        var firstName: String!
        var lastName: String!
    }
}
