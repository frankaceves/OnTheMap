//
//  Constants.swift
//  OnTheMap
//
//  Created by Frank Aceves on 3/29/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import Foundation

extension UdacityClient {
    // MARK: Constants
    struct Constants {
        static var studentKey: String = ""
        static var firstName: String = ""
        static var lastName: String = ""
        
        // MARK: API Key
        static let ApiKey = "insert API KEY HERE"
        
        // MARK: URLs
        //https://www.udacity.com/api/session
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL = "https://www.udacity.com/api/session/"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let username = ""
    }
    
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Login = "" //post session https://www.udacity.com/api/session
        static let Logout = "" //delete session; https://www.udacity.com/api/session
        static let GetUserData = "" // https://www.udacity.com/api/users/<user_id>
        
        
    }
    
    
}
