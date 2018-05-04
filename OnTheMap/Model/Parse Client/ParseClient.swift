//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/2/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit
import CoreLocation

class ParseClient: NSObject {
    var session = URLSession.shared
    // MARK: PROPERTIES
    var userLat: Double!
    var userLon: Double!
    var firstName: String?
    var lastName: String?
    
    // MARK: Initializers
    
    
    
    func getStudentInfo(_ completionHandlerfForGetStudentInfo: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        //1.  set parameters
        //2.  create url
        //3.  configure request
        var request1 = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt")!)
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
    
    func checkForObjectId(_ uniqueKey: String, _ completionHandlerfForCheckForObjectId: @escaping (_ result: Bool) -> Void) { //params UniqueKey from parseClient Constant
        //let uniqueKey = "5401038719"
        
        var urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        urlString.append("?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D")
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                return
            }
            //print(String(data: data!, encoding: .utf8)!)
            
            //var parsedResults: [String:AnyObject]!
            guard let parsedResults = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] else {
                print("parse query error")
                return
            }
            //print(parsedResults)
            
            guard let results = parsedResults["results"] as? [[String: AnyObject]] else {
                print("no results")
                return
            }
            print("results empty: \(results.isEmpty)")
            if results.isEmpty {
                completionHandlerfForCheckForObjectId(false)
            }
            //print(results)
            for result in results {
                
                if let objectId = result["objectId"] as? String { //insert objectID from parseClient constants.
                    print("objectID: \(objectId)")
                    completionHandlerfForCheckForObjectId(true)
                    
                }
            }
        }
        task.resume()
    }
    // POST STUDENT INFO
    func postLocation() {
        let lat = Float(ParseClient.sharedInstance().userLat)
        let lon = Float(ParseClient.sharedInstance().userLon)
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.Constants.studentKey)\", \"firstName\": \"\(UdacityClient.Constants.firstName)\", \"lastName\": \"\(UdacityClient.Constants.lastName)\",\"mapString\": \"Costa Mesa, CA\", \"mediaURL\": \"https://www.facebook.com\",\"latitude\": \(lat), \"longitude\": \(lon)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                print("error in your request")
                return
            }
            
            guard let data = data else {
                print("no data returned")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("status code returned other than 2xx")
                print(response as AnyObject)
                return
            }

        }
        task.resume()
    }
    
    // UPDATE STUDENT INFO
    private func updateStudentInfo(_ completionHandlerfForUpdateStudentInfo: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        // if results = parsedResults["updatedAt"] as string, completion (true, nil)
        // if no results, completion (false, error)
    }
    
    // FIND STUDENT LOCATION
    func findStudentLocation(location: String, completionHandlerForFindStudentLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        forwardGeocodeLocationString(locationString: location) { (success, error) in
            if success == success {
                //print("success")
                completionHandlerForFindStudentLocation(true, nil)
            }
        }
    }
    
    func forwardGeocodeLocationString(locationString: String, _ completionHandlerForGeocoder: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        CLGeocoder().geocodeAddressString(locationString) { (result, error) in
            if error != nil {
                print(error!)
                return
            }
            if let location = result, let coordinate = location[0].location?.coordinate {
                self.userLat = coordinate.latitude
                self.userLon = coordinate.longitude
                print("lat: \(self.userLat!), long: \(self.userLon!)")
                completionHandlerForGeocoder(true, nil)
            }
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
