//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Frank Aceves on 3/29/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - PROPERTIES
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
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
    //TODO: execute login api function
    //POST SESSION API METHOD?
    // MARK: Authentication (GET) Methods
    /*
     Steps for Authentication...
     https://www.udacity.com/api/session
     Method Type: POST
     Required Parameters:
     udacity - (Dictionary) a dictionary containing a username/password pair used for authentication
        username - (String) the username (email) for a Udacity student
        password - (String) the password for a Udacity student

     
     Step 1: Create a new request token
     Step 2a: Ask the user for permission via the website
     Step 3: Create a session ID
     Bonus Step: Go ahead and get the user id 😄!
     */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
