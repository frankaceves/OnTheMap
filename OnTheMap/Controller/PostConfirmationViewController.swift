//
//  PostConfirmationViewController.swift
//  OnTheMap
//
//  Created by Frank Anthony Aceves on 4/21/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit
import MapKit

class PostConfirmationViewController: UIViewController, MKMapViewDelegate {
    // MARK: - PROPERTIES
    let userLat = ParseClient.sharedInstance().userLat
    let userLon = ParseClient.sharedInstance().userLon
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let lat = CLLocationDegrees(userLat!)
        let long = CLLocationDegrees(userLon!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
//        let first = dictionary.studentFirstName!
//        let last = dictionary.studentLastName!
//        let mediaURL = dictionary.studentMediaURL!
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotation.title = "\(first) \(last)"
//        annotation.subtitle = mediaURL
        
        
        DispatchQueue.main.async {
        self.mapView.addAnnotation(annotation)
            
        }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
