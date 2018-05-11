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
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.stopAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ACTIONS
    
    @IBAction func signUpPressed(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.shared.open(url, options: [:]) { (success) in
            //
        }
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
            //execute login request function
            activityView.startAnimating()
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            
            UdacityClient.sharedInstance().loginRequest(username: username, password: password, completionHandlerForLogin: { (success, sessionID, error) in
                if success {
                    UdacityClient.sharedInstance().getPublicData()
                    DispatchQueue.main.async {
                        
                        self.completeLogin()
                        //self.activityView.stopAnimating()
                    }
                } else {
                    //print("error with login request in LoginPressed func, LoginVC.swift")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
