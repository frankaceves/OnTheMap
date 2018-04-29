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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

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
        //self.completeLogin() // REMOVE when ready to ship.
        // MARK - UNCOMMENT TO ENABLE LOGIN REQUEST
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Login Failed", message: "Missing Email or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
            //enable UI
        } else {
            //disable UI
            //execute login request function
            let username = usernameTextField.text!
            let password = passwordTextField.text!

            UdacityClient.sharedInstance().loginRequest(username: username, password: password, completionHandlerForLogin: { (success, sessionID, error) in
                if success {
                    DispatchQueue.main.async {
                        self.completeLogin()
                    }
                } else {
                    //print("error with login request in LoginPressed func, LoginVC.swift")
                    DispatchQueue.main.async {
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
