//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/18/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {
    // MARK: - PROPERTIES
    
    @IBOutlet weak var locationStringTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    let device = UIDevice.current
    
    // MARK: Text Field Delegate Objects
    let locationTextDelegate = LocationTextDelegate()
    
    // MARK: - LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        device.beginGeneratingDeviceOrientationNotifications()
        subscribeToKeyboardNotifications()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationStringTextField.delegate = locationTextDelegate
        urlTextField.delegate = locationTextDelegate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
        device.endGeneratingDeviceOrientationNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPosting(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        
        if locationStringTextField.text!.isEmpty || urlTextField.text!.isEmpty {
            let alert = UIAlertController(title: nil, message: "Location & URL are required!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            
        } else {
            let userLocation = locationStringTextField.text!
            let userURL = urlTextField.text!
            //execute function to check validity of url?
            
            
            let activityView = UIViewController.activateSpinner(onView: self.view)
            
            ParseClient.sharedInstance().findStudentLocation(location: userLocation, userURL: userURL, completionHandlerForFindStudentLocation: { (success, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Could Not Find Location", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        UIViewController.deactivateSpinner(spinner: activityView)
                    }
                }
                
                if success == true {
                    DispatchQueue.main.async {
                        
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostConfirmationViewController")
                        self.present(controller, animated: true, completion: nil)
                        UIViewController.deactivateSpinner(spinner: activityView)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Invalid URL", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        UIViewController.deactivateSpinner(spinner: activityView)
                    }
                }
            })
        }
    }
    
    // MARK: SHOW/HIDE KEYBOARD FUNCTIONS
    @objc func keyboardWillShow(_ notification: Notification) {
        if device.orientation.isLandscape {
            if locationStringTextField.isEditing || urlTextField.isEditing {
                view.frame.origin.y = 0 - (getKeyboardHeight(notification) - 50)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
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
