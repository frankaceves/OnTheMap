//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Frank Aceves on 3/29/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    // MARK: - PROPERTIES
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let device = UIDevice.current
    
    // MARK: Text Field Delegate Objects
    let locationTextDelegate = LocationTextDelegate()
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.stopAnimating()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = locationTextDelegate
        passwordTextField.delegate = locationTextDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        device.beginGeneratingDeviceOrientationNotifications()
        subscribeToKeyboardNotifications()
        
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
    
    // MARK: - ACTIONS
    
    @IBAction func signUpPressed(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Login Failed", message: "Missing Email or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
            //enable UI
        } else {
            //disable UI
            
            activityView.startAnimating()
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            
            UdacityClient.sharedInstance().loginRequest(username: username, password: password, completionHandlerForLogin: { (success, sessionID, error) in
                if success {
                    UdacityClient.sharedInstance().getPublicData()
                    DispatchQueue.main.async {
                        self.completeLogin()
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        let alert = UIAlertController(title: "Login Failed", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                }
            })

        }
    }
    
    // MARK: Login
    
    private func completeLogin() {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "StudentTabController") 
        present(controller, animated: true, completion: nil)
        self.activityView.stopAnimating()
    }
    
    // MARK: SHOW/HIDE KEYBOARD FUNCTIONS
    @objc func keyboardWillShow(_ notification: Notification) {
        if device.orientation.isLandscape {
            if usernameTextField.isEditing || passwordTextField.isEditing {
                view.frame.origin.y = 0 - (getKeyboardHeight(notification) - 60)
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
