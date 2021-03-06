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
    let userlocationString = ParseClient.sharedInstance().locationString
    
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
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = userlocationString
        
        
        let mapSpan = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: mapSpan)
        self.mapView.setRegion(region, animated: true)
        
        
        
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        
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
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if let id = ParseClient.sharedInstance().objectID  {
    
            ParseClient.sharedInstance().updateStudentInfo(objectID: id, { (success, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "UPDATE ERROR", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                
                if success == true {
                    
                    DispatchQueue.main.async {
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            })
        } else {
        
        
        ParseClient.sharedInstance().postLocation { (success, error) in
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "POSTING ERROR", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            if success == true {
                
                DispatchQueue.main.async {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
                
            }
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
