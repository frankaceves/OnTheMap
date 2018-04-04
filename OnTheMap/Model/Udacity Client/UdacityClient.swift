//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/2/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    // MARK: Properties
    // do we need these Strings?
    var udacityUserName: String!
    var udacityPassword: String!
    // shared session
    var session = URLSession.shared
    
    //TODO: execute login api function
    func loginRequest(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) { //eventually add parameters to take username and password, and add them to request body
        /*
         
         https://www.udacity.com/api/session
         Method Type: POST
         Required Parameters:
         udacity - (Dictionary) a dictionary containing a username/password pair used for authentication
         username - (String) the username (email) for a Udacity student
         password - (String) the password for a Udacity student
         */
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
            //request.httpBody = "{\"udacity\": {\"username\": \"frankaceves@gmail.com\", \"password\": \"Emb0dydrum5!\"}}".data(using: .utf8)
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
            //print(String(data: newData!, encoding: .utf8)!)
        
        
            //use data
            let parsedResults: [String:AnyObject]!
            
            do {
                parsedResults = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String: AnyObject]
            } catch {
                
                print("error parsing results")
                return
            }
            
            //print(parsedResults)
            guard let sessionInfo = parsedResults["session"] else {
                print("sessionInfo error")
                return
            }
            
            if let sessionID = sessionInfo["id"] as? String {
            //if data returned contains a session ID, instantiate new view controller
                print("sessionID: \(sessionID)")
                completionHandlerForLogin(true, "sessionID: \(sessionID)", nil)
            } else {
                print("sessionID error")
                completionHandlerForLogin(false, nil, "sessionID error; could not retrieve a session ID")
            }
            
        }
        
        task.resume()
    }
    
    
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
}
