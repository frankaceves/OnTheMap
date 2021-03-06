//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Frank Anthony Aceves on 4/10/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController, MKMapViewDelegate {
    // - MARK: PROPERTIES
    //TODO: set up mapview property (to reload when reload button is pressed).
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let activityIndicator = UIViewController.activateSpinner(onView: self.mapView)
        
        //clear annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        ParseClient.sharedInstance().getStudentInfo { (results, error) in
            //print("---GetStudentInfo called---")
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "DOWNLOAD ERROR", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    UIViewController.deactivateSpinner(spinner: activityIndicator)
                }
            }
            
            if let locations = results {
                var annotations = [MKPointAnnotation]()
                
                for dictionary in locations {
                    
                    let lat = CLLocationDegrees(dictionary.studentLatitude!)
                    let long = CLLocationDegrees(dictionary.studentlongitude!)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary.studentFirstName!
                    let last = dictionary.studentLastName!
                    let mediaURL = dictionary.studentMediaURL!
                    
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(annotations)
                    UIViewController.deactivateSpinner(spinner: activityIndicator)
                }
                
                
                
            } else {
                print(error!)
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // create and set the logout button
//        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        // create and set the reload button
        //parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "RELOAD", style: .plain, target: self, action: #selector(reloadStudentInfo))
        //        parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadStudentInfo))
//        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadStudentInfo))
//
//        let postButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postLocation))
//        parent!.navigationItem.rightBarButtonItems = [reloadButton, postButton]
    }
    
    @IBAction func reloadStudentInfo() {
        self.viewWillAppear(true)
        
    }
    
    @IBAction func logout() {
        UdacityClient.sharedInstance().logoutRequest { (success, error) in
            if error != nil {
                print("logout error")
            } else {
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction private func postLocationPressed() {
        
        ParseClient.sharedInstance().checkForObjectId(UdacityClient.Constants.studentKey) { (success) in
            
            if !success {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController") as UIViewController
                self.present(controller, animated: true, completion: nil)
            } else {
                //if objectID exists, notification for overwrite
                let alert = UIAlertController(title: nil, message: "User \"\(UdacityClient.Constants.firstName) \(UdacityClient.Constants.lastName)\" has already posted a Student Location. Would you like to overwrite their location?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
                    print("overwrite pressed")
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController") as UIViewController
                    self.present(controller, animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //let app = UIApplication.shared
//            if let toOpen = view.annotation?.subtitle! {
//                let url = URL(string: toOpen)!
//                app.open(url, options: [:], completionHandler: nil)
//            if let studentURLstring = view.annotation?.subtitle!, let studentURL = URL(string: studentURLstring) {
//                if UIApplication.shared.canOpenURL(studentURL) {
//                    UIApplication.shared.open(studentURL, options: [:], completionHandler: nil)
//                } else {
//                    let alert = UIAlertController(title: "Invalid Link", message: "This link cannot be opened.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//                    self.present(alert, animated: true)
//                }
//            } else {
//                let alert = UIAlertController(title: "Invalid Link", message: "This link cannot be opened.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }
//        }
        
        if let studentURLstring = view.annotation?.subtitle!, let studentURL = URL(string: studentURLstring) {
            if UIApplication.shared.canOpenURL(studentURL) {
                UIApplication.shared.open(studentURL, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "URL Won't Open", message: "This URL is Not Valid and Won't Open", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        } else {
            let alert = UIAlertController(title: "URL not valid", message: "Student's provided URL information contains illegal characters or spaces and will not open.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    }
//    if let studentURLstring = student.studentMediaURL, let studentURL = URL(string: studentURLstring) {
//        if UIApplication.shared.canOpenURL(studentURL) {
//            UIApplication.shared.open(studentURL, options: [:], completionHandler: nil)
//        } else {
//            print("this url is not valid")
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


