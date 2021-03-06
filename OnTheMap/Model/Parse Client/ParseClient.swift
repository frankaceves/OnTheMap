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
    var objectID: String?
    var locationString: String?
    var userURL: String?
    
    // MARK: Initializers
    
    
    
    func getStudentInfo(_ completionHandlerfForGetStudentInfo: @escaping (_ result: [StudentInformation]?, _ error: String?) -> Void) {
        //1.  set parameters
        //2.  create url
        //3.  configure request
        var request1 = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt&limit=200")!)
        request1.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request1.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session1 = URLSession.shared
        
        //    4.  Make request (task) check for errors (error, data, 2xx statuscode)
        let task1 = session1.dataTask(with: request1) { data, response, error in
            // Handle error...
            
            guard (error == nil) else {
                print("error in your request")
                completionHandlerfForGetStudentInfo(nil, error!.localizedDescription)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                //print("status code returned other than 2xx")
                completionHandlerfForGetStudentInfo(nil, "The request returned other than 2xx.  Please Try Again Later.")
                return
            }
            guard let data = data else {
                //print("no data returned")
                completionHandlerfForGetStudentInfo(nil, "No Data Returned.  Please Try Again Later.")
                return
            }
            //RAW JSON DATA
            //print(String(data: data, encoding: .utf8)!)
            
            //    5.  parse data (deserialize json data)
            let parsedResults: [String: AnyObject]!
            
            do {
                parsedResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                //print("error parsing data")
                completionHandlerfForGetStudentInfo(nil, "Error Parsing JSON Data.  Please Try Again Later.")
                return
            }
            
            
            if let results = parsedResults["results"] as? [[String:AnyObject]] {
                let students = StudentInformation.studentsFromResults(results)
                completionHandlerfForGetStudentInfo(students, nil)
            } else {
                completionHandlerfForGetStudentInfo(nil, "Error parsing 'Results' from JSON data.  Please Try Again Later.")
            }
            
            
            
            
            
        }
        //    7.  Start Request
        task1.resume()
        
    }
    
    // MARK: CHECK FOR OBJECT ID
    func checkForObjectId(_ uniqueKey: String, _ completionHandlerfForCheckForObjectId: @escaping (_ result: Bool) -> Void) { //params UniqueKey from parseClient Constant
        
        
        var urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        urlString.append("?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D")
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            //print(String(data: data!, encoding: .utf8)!)
            
            
            guard let parsedResults = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] else {
                print("parse query error")
                return
            }
            
            
            guard let results = parsedResults["results"] as? [[String: AnyObject]] else {
                print("no results")
                return
            }
            
            if results.isEmpty {
                completionHandlerfForCheckForObjectId(false)
            }
            
            for result in results {
                
                if let objectID = result["objectId"] as? String { //insert objectID from parseClient constants.
                    //print("objectID = \(objectID)")
                    self.objectID = objectID
                    //print(result as AnyObject)
                    completionHandlerfForCheckForObjectId(true)
                    
                }
            }
        }
        task.resume()
    }
    // MARK: POST STUDENT INFO
    func postLocation(_ completionHandlerfForPostLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let lat = Float(ParseClient.sharedInstance().userLat)
        let lon = Float(ParseClient.sharedInstance().userLon)
        
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.Constants.studentKey)\", \"firstName\": \"\(UdacityClient.Constants.firstName)\", \"lastName\": \"\(UdacityClient.Constants.lastName)\",\"mapString\": \"\(ParseClient.sharedInstance().locationString!)\", \"mediaURL\": \"\(ParseClient.sharedInstance().userURL!)\",\"latitude\": \(lat), \"longitude\": \(lon)}".data(using: .utf8)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                print("error in your request")
                return
            }
            
            guard let data = data else {
                print("no data returned")
                completionHandlerfForPostLocation(false, "Could Not Post Student Location")
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("status code returned other than 2xx")
                completionHandlerfForPostLocation(false, "Could Not Post Student Location")
                return
            }
            
            guard let parsedResults = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                completionHandlerfForPostLocation(false, "Could Not Post Student Location")
                return
            }
            
            
            if let objectID = parsedResults["objectId"] as? String {
                self.objectID = objectID
                //print("new object ID: \(self.objectID!)")
                completionHandlerfForPostLocation(true, nil)
            } else {
                completionHandlerfForPostLocation(false, "Could Not Post Student Location")
            }
            

        }
        task.resume()
    }
    
    // UPDATE STUDENT INFO
    func updateStudentInfo(objectID: String, _ completionHandlerfForUpdateStudentInfo: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.Constants.studentKey)\", \"firstName\": \"\(UdacityClient.Constants.firstName)\", \"lastName\": \"\(UdacityClient.Constants.lastName)\",\"mapString\": \"\(self.locationString!)\", \"mediaURL\": \"\(self.userURL!)\",\"latitude\": \(Float(self.userLat!)), \"longitude\": \(Float(self.userLon!))}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            guard let data = data else {
                print("no data returned")
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("status code returned other than 2xx")
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
                
                return
            }
            
            guard let parsedResults = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                print("parse query error")
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
                return
            }
            
            //print(String(data: data, encoding: .utf8)!)
            
            if let results = parsedResults["updatedAt"] as? String {
                print(results)
                completionHandlerfForUpdateStudentInfo(true, nil)
            } else {
            // if no results, completion (false, error)
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
            }
            
        }
        task.resume()
    }
    
    private func checkURLValidity(userURL: String?) -> Bool {
        if let urlString = userURL, let url = URL(string: urlString)  {
            //print("can open URL: \(UIApplication.shared.canOpenURL(url))")
            if UIApplication.shared.canOpenURL(url) == true {
                self.userURL = userURL
                return true
            }
        }
        return false
    }
    
    // FIND STUDENT LOCATION
    func findStudentLocation(location: String, userURL: String, completionHandlerForFindStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        forwardGeocodeLocationString(locationString: location) { (success, error) in
            if success == true {
                self.locationString = location

                if self.checkURLValidity(userURL: userURL) == true {
                    completionHandlerForFindStudentLocation(true, nil)
                } else {
                    //print(error)
                    completionHandlerForFindStudentLocation(false, "Please enter a valid URL with https://")
                }
            } else {
                completionHandlerForFindStudentLocation(false, error)
                
            }
        }
    }
    
    func forwardGeocodeLocationString(locationString: String, _ completionHandlerForGeocoder: @escaping (_ success: Bool, _ error: String?) -> Void) {
        CLGeocoder().geocodeAddressString(locationString) { (result, error) in
            if error != nil {
                completionHandlerForGeocoder(false, "Please Enter a City, Address, Postal Code, or Intersection")
                return
            }
            if let location = result, let coordinate = location[0].location?.coordinate {
                self.userLat = coordinate.latitude
                self.userLon = coordinate.longitude
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
