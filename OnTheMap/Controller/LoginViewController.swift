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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
