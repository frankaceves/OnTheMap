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
        //add activity indicator
        let activityIndicator = UIViewController.activateSpinner(onView: self.mapView)
        
        //clear annotations
        self.mapView.removeAnnotations(mapView.annotations)
        //
        ParseClient.sharedInstance().getStudentInfo { (results, error) in
            print("---GetStudentInfo called---")
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
        print("reload pressed in student Map")
        // reload map view
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
        //when button clicked, check for object ID
        ParseClient.sharedInstance().checkForObjectId(UdacityClient.Constants.studentKey) { (success) in
            //if no objectID, instantiate PostLocationVC
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
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                //app.openURL(URL(string: toOpen)!)
                let url = URL(string: toOpen)!
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension UIViewController {
//    class func activateSpinner(onView : UIView) -> UIView {
//        let spinnerView = UIView.init(frame: onView.bounds)
//        spinnerView.backgroundColor = UIColor.init(white: 0.10, alpha: 0.75)
//
//        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
//
//        ai.startAnimating()
//        ai.center = spinnerView.center
//
//        DispatchQueue.main.async {
//            spinnerView.addSubview(ai)
//            onView.addSubview(spinnerView)
//        }
//
//        return spinnerView
//    }
//
//    class func deactivateSpinner(spinner :UIView) {
//        DispatchQueue.main.async {
//            spinner.removeFromSuperview()
//        }
//    }
//}

