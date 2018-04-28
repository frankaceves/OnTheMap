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
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        
        // MARK: Authentication
        static let AuthenticationTokenNew = "/authentication/token/new"
        
        // MARK: Search
        static let SearchMovie = "/search/movie"
        
        // MARK: Config
        
        
    }
    
    
}
