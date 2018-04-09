//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/2/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    var session = URLSession.shared
    
    // MARK: Initializers
    
    
    
    func getStudentInfo(_ completionHandlerfForGetStudentInfo: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        //1.  set parameters
        //2.  create url
        //3.  configure request
        var request1 = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request1.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request1.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session1 = URLSession.shared
        
        //    4.  Make request (task) check for errors (error, data, 2xx statuscode)
        let task1 = session1.dataTask(with: request1) { data, response, error in
            // Handle error...
            
            guard (error == nil) else {
                print("error in your request")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("status code returned other than 2xx")
                return
            }
            guard let data = data else {
                print("no data returned")
                return
            }
            //RAW JSON DATA
            //print(String(data: data, encoding: .utf8)!)
            
            //    5.  parse data (deserialize json data)
            let parsedResults: [String: AnyObject]!
            
            do {
                parsedResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("error parsing data")
                return
            }
            
            //print(parsedResults)
            if let results = parsedResults["results"] as? [[String:AnyObject]] {
                let students = StudentInformation.studentsFromResults(results)
                completionHandlerfForGetStudentInfo(students, nil)
            } else {
                completionHandlerfForGetStudentInfo(nil, NSError(domain: "student location", code: 0, userInfo: [NSLocalizedDescriptionKey:"could not parse student info into dictionary"]))
            }
            
            
            
            //    6.  use the data (assign data to local properties)
            
        }
        //    7.  Start Request (task.resume)
        task1.resume()
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
